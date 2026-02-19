# frozen_string_literal: true

module SongstatsSDK
  module Resources
    class Stations < Base
      def station_request(radio_type:, name:, country_code:, website:, stream_url: nil, city_name: nil, frequency: nil,
        contact: nil, comment: nil, **extra)
        raise ArgumentError, "radio_type is required" if radio_type.to_s.empty?
        raise ArgumentError, "name is required" if name.to_s.empty?
        raise ArgumentError, "country_code is required" if country_code.to_s.empty?
        raise ArgumentError, "website is required" if website.to_s.empty?

        payload = {
          radio_type: radio_type,
          name: name,
          country_code: country_code,
          website: website,
          stream_url: stream_url,
          city_name: city_name,
          frequency: frequency,
          contact: contact,
          comment: comment
        }.merge(extra)

        post("stations/station_request", json: payload)
      end
    end
  end
end
