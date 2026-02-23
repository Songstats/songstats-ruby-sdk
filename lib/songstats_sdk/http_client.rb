# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module SongstatsSDK
  HTTPResponse = Struct.new(:status, :body, :headers, keyword_init: true)

  class NetHTTPAdapter
    METHOD_MAP = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      delete: Net::HTTP::Delete
    }.freeze

    def request(method:, base_url:, path:, headers:, params:, json:, timeout:)
      uri = URI.join("#{base_url.chomp('/')}/", path.delete_prefix('/'))
      query = URI.encode_www_form(params || {})
      uri.query = [uri.query, query].compact.reject(&:empty?).join("&") unless query.empty?

      request_class = METHOD_MAP.fetch(method.to_sym) { raise ArgumentError, "Unsupported HTTP method: #{method}" }
      request = request_class.new(uri)
      headers.each { |key, value| request[key] = value unless value.nil? }

      if json
        request["content-type"] ||= "application/json"
        request.body = JSON.generate(json)
      end

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = timeout
      http.read_timeout = timeout

      response = http.request(request)
      HTTPResponse.new(status: response.code.to_i, body: response.body.to_s, headers: response.to_hash)
    end
  end

  class HTTPClient
    DEFAULT_BASE_URL = "https://data.songstats.com"
    DEFAULT_TIMEOUT_SECONDS = 30
    RETRYABLE_STATUS_CODES = [429, 500, 502, 503, 504].freeze
    RETRYABLE_EXCEPTIONS = [
      EOFError,
      IOError,
      SocketError,
      Timeout::Error,
      Errno::ECONNRESET,
      Errno::ECONNREFUSED,
      Errno::ETIMEDOUT,
      Net::OpenTimeout,
      Net::ReadTimeout
    ].freeze

    def initialize(api_key:, base_url: DEFAULT_BASE_URL, timeout: DEFAULT_TIMEOUT_SECONDS, max_retries: 2, adapter: nil,
      user_agent: nil)
      raise ArgumentError, "api_key is required" if api_key.to_s.empty?
      raise ArgumentError, "max_retries must be >= 0" if max_retries.to_i.negative?

      @api_key = api_key
      @base_url = base_url
      @timeout = timeout
      @max_retries = max_retries.to_i
      @adapter = adapter || NetHTTPAdapter.new
      @user_agent = user_agent || "songstats-ruby-sdk/#{VERSION}"
    end

    def close
      @adapter.close if @adapter.respond_to?(:close)
    end

    def request(method, path, params: nil, json: nil)
      endpoint = "/enterprise/v1/#{path.to_s.delete_prefix('/')}"
      attempts = 0

      loop do
        begin
          response = @adapter.request(
            method: method.to_sym,
            base_url: @base_url,
            path: endpoint,
            headers: request_headers,
            params: params,
            json: json,
            timeout: @timeout
          )
        rescue *RETRYABLE_EXCEPTIONS => e
          if attempts < @max_retries
            sleep(backoff_seconds(attempts))
            attempts += 1
            next
          end
          raise SongstatsTransportError, e.message
        end

        if RETRYABLE_STATUS_CODES.include?(response.status) && attempts < @max_retries
          sleep(backoff_seconds(attempts))
          attempts += 1
          next
        end

        return decode_response(response.body) if response.status.between?(200, 299)

        raise build_api_error(response)
      end
    end

    private

    def request_headers
      {
        "apikey" => @api_key,
        "accept" => "application/json",
        "user-agent" => @user_agent
      }
    end

    def backoff_seconds(attempt)
      0.2 * (2**attempt)
    end

    def decode_response(body)
      return nil if body.nil? || body.strip.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      { "raw" => body }
    end

    def build_api_error(response)
      payload = decode_response(response.body)
      message = "HTTP #{response.status}"

      if payload.is_a?(Hash)
        message = payload["message"] || payload["error"] || message
      end

      SongstatsAPIError.new(message: message, status_code: response.status, payload: payload)
    end
  end
end
