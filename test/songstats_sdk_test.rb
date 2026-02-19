# frozen_string_literal: true

require_relative "test_helper"

class SongstatsSDKTest < Minitest::Test
  def test_info_status_sends_apikey_header
    adapter = FakeAdapter.new(
      responses: [response(200, { result: "success" })]
    )
    client = SongstatsSDK::Client.new(api_key: "test_key", http_adapter: adapter)

    data = client.info.status

    assert_equal "success", data["result"]
    assert_equal "test_key", adapter.requests.last.headers["apikey"]
    assert_equal "/enterprise/v1/status", adapter.requests.last.path
  end

  def test_info_sources_and_definitions_routes
    adapter = FakeAdapter.new(
      responses: [
        response(200, { result: "success", sources: [] }),
        response(200, { result: "success", definitions: {} })
      ]
    )
    client = SongstatsSDK::Client.new(api_key: "test_key", http_adapter: adapter)

    client.info.sources
    assert_equal "/enterprise/v1/sources", adapter.requests[-1].path

    client.info.definitions
    assert_equal "/enterprise/v1/definitions", adapter.requests[-1].path
  end

  def test_tracks_info_hits_expected_route_and_params
    adapter = FakeAdapter.new(
      responses: [response(200, { result: "success" })]
    )
    client = SongstatsSDK::Client.new(api_key: "test_key", http_adapter: adapter)

    client.tracks.info(songstats_track_id: "abcd1234", with_links: true)
    request = adapter.requests.last

    assert_equal "/enterprise/v1/tracks/info", request.path
    assert_equal "abcd1234", request.params[:songstats_track_id]
    assert_equal "true", request.params[:with_links]
  end

  def test_collaborators_top_curators_is_mapped
    adapter = FakeAdapter.new(
      responses: [response(200, { result: "success" })]
    )
    client = SongstatsSDK::Client.new(api_key: "test_key", http_adapter: adapter)

    client.collaborators.top_curators(songstats_collaborator_id: "collab1234", source: "spotify")
    request = adapter.requests.last

    assert_equal "/enterprise/v1/collaborators/top_curators", request.path
    assert_equal "collab1234", request.params[:songstats_collaborator_id]
    assert_equal "spotify", request.params[:source]
  end

  def test_api_error_raises_songstats_api_error
    adapter = FakeAdapter.new(
      responses: [response(401, { result: "error", message: "Invalid Api Key" })]
    )
    client = SongstatsSDK::Client.new(api_key: "bad_key", http_adapter: adapter)

    err = assert_raises(SongstatsSDK::SongstatsAPIError) do
      client.info.status
    end

    assert_equal 401, err.status_code
    assert_includes err.to_s, "Invalid Api Key"
  end

  def test_identifier_validation
    adapter = FakeAdapter.new(
      responses: [response(200, { result: "success" })]
    )
    client = SongstatsSDK::Client.new(api_key: "test_key", http_adapter: adapter)

    assert_raises(ArgumentError) { client.labels.info }
  end

  def test_artists_search_route
    adapter = FakeAdapter.new(
      responses: [response(200, { result: "success", results: [] })]
    )
    client = SongstatsSDK::Client.new(api_key: "test_key", http_adapter: adapter)

    client.artists.search(q: "fred again", limit: 10)

    request = adapter.requests.last
    assert_equal "/enterprise/v1/artists/search", request.path
    assert_equal "fred again", request.params[:q]
    assert_equal 10, request.params[:limit]
  end

  private

  def response(status, payload)
    SongstatsSDK::HTTPResponse.new(status: status, body: JSON.generate(payload), headers: {})
  end
end
