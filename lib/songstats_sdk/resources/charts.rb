# frozen_string_literal: true

module SongstatsSDK
  module Resources
    class Charts < Base
      def tracks(country_code:, source: nil, **params)
        raise ArgumentError, "country_code is required" if country_code.to_s.empty?

        query = { country_code: country_code, source: source }.merge(params)
        get("charts/tracks", params: query)
      end
    end
  end
end
