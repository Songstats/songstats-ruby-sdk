# Songstats Ruby SDK

Ruby SDK for the Songstats Enterprise API (`/enterprise/v1`).

## Install

```bash
bundle install
bundle exec rake test
```

For local usage in another project:

```ruby
gem "songstats-ruby-sdk", path: "/path/to/songstats-ruby-sdk"
```

## Quick Start

```ruby
require "songstats_sdk"

client = SongstatsSDK::Client.new(api_key: "YOUR_API_KEY")

status = client.info.status
track = client.tracks.info(songstats_track_id: "abcd1234")
artist_stats = client.artists.stats(songstats_artist_id: "abcd1234", source: "spotify")
```

## Authentication

The SDK sends your key in the `apikey` header, matching Songstats enterprise auth.

## Included Resource Clients

- `client.info`
- `client.tracks`
- `client.artists`
- `client.collaborators`
- `client.labels`
- `client.charts`
- `client.stations`

## Error Handling

- `SongstatsSDK::SongstatsAPIError`: non-2xx HTTP response
- `SongstatsSDK::SongstatsTransportError`: transport/connectivity failure

## Route Coverage Audit

See `docs/enterprise_routes_audit.md` for the Rails route to SDK method mapping.
