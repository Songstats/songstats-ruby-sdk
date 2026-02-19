# Songstats Ruby SDK

Official Ruby client for the **Songstats Enterprise API**.

📦 RubyGems: https://rubygems.org/gems/songstats-ruby-sdk  
📚 API Documentation: https://docs.songstats.com
🔑 API Key Access: Please contact api@songstats.com

---

## Requirements

- Ruby >= 3.0

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
