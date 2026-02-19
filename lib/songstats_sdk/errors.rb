# frozen_string_literal: true

module SongstatsSDK
  class SongstatsError < StandardError; end

  class SongstatsTransportError < SongstatsError; end

  class SongstatsAPIError < SongstatsError
    attr_reader :status_code, :payload

    def initialize(message:, status_code:, payload: nil)
      @error_message = message
      super(@error_message)
      @status_code = status_code
      @payload = payload
    end

    def to_s
      "Songstats API error (#{status_code}): #{@error_message}"
    end
  end
end
