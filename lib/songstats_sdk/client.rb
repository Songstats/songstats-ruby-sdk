# frozen_string_literal: true

module SongstatsSDK
  class Client
    attr_reader :info, :tracks, :artists, :collaborators, :labels, :charts, :stations

    def initialize(api_key:, base_url: HTTPClient::DEFAULT_BASE_URL, timeout: HTTPClient::DEFAULT_TIMEOUT_SECONDS,
      max_retries: 2, http_adapter: nil, user_agent: nil)
      @http = HTTPClient.new(
        api_key: api_key,
        base_url: base_url,
        timeout: timeout,
        max_retries: max_retries,
        adapter: http_adapter,
        user_agent: user_agent
      )

      @info = Resources::Info.new(@http)
      @tracks = Resources::Tracks.new(@http)
      @artists = Resources::Artists.new(@http)
      @collaborators = Resources::Collaborators.new(@http)
      @labels = Resources::Labels.new(@http)
      @charts = Resources::Charts.new(@http)
      @stations = Resources::Stations.new(@http)
    end

    def close
      @http.close
    end
  end
end
