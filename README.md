# Songstats Ruby SDK

Official Ruby client for the **Songstats Enterprise API**.

📦 RubyGems: https://rubygems.org/gems/songstats-ruby-sdk  
📚 API Documentation: https://developers.stats.company/songstats<br>
🔑 API Key Access: Please contact api@songstats.com

---

## Requirements

- Ruby >= 3.2

---

## Installation

Add to your `Gemfile`:

    gem "songstats-ruby-sdk"

Then install:

    bundle install

Or install directly via RubyGems:

    gem install songstats-ruby-sdk

---

## Quick Start

    require "songstats_sdk"

    client = SongstatsSDK::Client.new(
      api_key: ENV["SONGSTATS_API_KEY"]
    )

    # API status
    status = client.info.status

    # Track information
    track = client.tracks.info(
      songstats_track_id: "abcd1234"
    )

    # Artist statistics
    artist_stats = client.artists.stats(
      songstats_artist_id: "abcd1234",
      source: "spotify"
    )

---

## Authentication

All requests include your API key in the `apikey` header.

You can generate an API key in your Songstats Enterprise dashboard.

We recommend storing your key securely in environment variables:

    export SONGSTATS_API_KEY=your_key_here

---

## Available Resource Clients

- `client.info`
- `client.tracks`
- `client.artists`
- `client.collaborators`
- `client.labels`

Info endpoints:
- `client.info.sources` -> `/sources`
- `client.info.status` -> `/status`
- `client.info.definitions` -> `/definitions`

---

## Error Handling

    begin
      client.tracks.info(songstats_track_id: "invalid")
    rescue SongstatsSDK::SongstatsAPIError => e
      puts "API error: #{e.message}"
    rescue SongstatsSDK::SongstatsTransportError => e
      puts "Transport error: #{e.message}"
    end

---

## Development

To work on the SDK locally:

    git clone https://github.com/songstats/songstats-ruby-sdk.git
    cd songstats-ruby-sdk
    bundle install
    bundle exec rake test

---

## Versioning

This SDK follows Semantic Versioning (SemVer).

---

## License

MIT

The client runs in plain Ruby without Rails or Active Support. Request parameters accept a hash or `nil`; empty hashes and nil-valued entries are omitted.

## Request retries

`max_retries` applies only to GET requests. Write requests are attempted once
because a transport failure or server error can occur after a write has already
succeeded. Check the resulting state before retrying a write.

## Albums (beta)

Requires Songstats album beta access. Member/entity keys must also supply an artist or label parent. Album info includes paginated known tracks; pass its returned `next_cursor` as `cursor` to the same info method. Artist and label catalogs accept `catalog_type=albums`; track catalogs remain the default.

```
client.albums.info(songstats_album_id: "...")
client.albums.stats(songstats_album_id: "...", source: "spotify")
client.artists.catalog(songstats_artist_id: "...", catalog_type: "albums")
```

Album stats default to release-member recording counters. Shared counters are not release-exclusive. `scope=recording_catalog` opts into wider recording performance and is unavailable for label-scoped calls. Spotify and TIDAL return `popularity_current` (0–100); Deezer returns `saves_total` (album favourites). Each uses the highest measured value among eligible releases on that platform, not a sum across editions. Values may be unavailable or stale. No separate album catalog/tracks method is provided.
