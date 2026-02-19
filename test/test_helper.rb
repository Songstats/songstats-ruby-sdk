# frozen_string_literal: true

require "json"
require "minitest/autorun"

require_relative "../lib/songstats_sdk"

class FakeAdapter
  Request = Struct.new(:method, :base_url, :path, :headers, :params, :json, :timeout, keyword_init: true)

  attr_reader :requests

  def initialize(responses:)
    @responses = responses
    @requests = []
  end

  def request(method:, base_url:, path:, headers:, params:, json:, timeout:)
    @requests << Request.new(
      method: method,
      base_url: base_url,
      path: path,
      headers: headers,
      params: params,
      json: json,
      timeout: timeout
    )

    response = @responses.shift
    raise "No fake response configured" if response.nil?
    raise response if response.is_a?(Exception)

    response
  end
end
