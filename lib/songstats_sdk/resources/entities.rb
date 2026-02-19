# frozen_string_literal: true

module SongstatsSDK
  module Resources
    class Entity < Base
      def initialize(http_client, resource:, identifier_keys:)
        super(http_client)
        @resource = resource
        @identifier_keys = identifier_keys
      end

      def info(**params)
        get("#{@resource}/info", params: with_identifier(params))
      end

      def stats(**params)
        get("#{@resource}/stats", params: with_identifier(params))
      end

      def historic_stats(**params)
        get("#{@resource}/historic_stats", params: with_identifier(params))
      end

      def audience(**params)
        get("#{@resource}/audience", params: with_identifier(params))
      end

      def audience_details(country_code:, **params)
        raise ArgumentError, "country_code is required" if country_code.to_s.empty?

        query = with_identifier(params)
        query[:country_code] = country_code
        get("#{@resource}/audience/details", params: query)
      end

      def catalog(**params)
        get("#{@resource}/catalog", params: with_identifier(params))
      end

      def search(q:, **params)
        raise ArgumentError, "q is required" if q.to_s.empty?

        get("#{@resource}/search", params: params.merge(q: q))
      end

      def activities(**params)
        get("#{@resource}/activities", params: with_identifier(params))
      end

      def songshare(**params)
        get("#{@resource}/songshare", params: with_identifier(params))
      end

      def top_tracks(**params)
        get("#{@resource}/top_tracks", params: with_identifier(params))
      end

      def top_playlists(**params)
        get("#{@resource}/top_playlists", params: with_identifier(params))
      end

      def top_curators(**params)
        get("#{@resource}/top_curators", params: with_identifier(params))
      end

      def top_commentors(**params)
        get("#{@resource}/top_commentors", params: with_identifier(params))
      end

      def add_link_request(link:, **params)
        raise ArgumentError, "link is required" if link.to_s.empty?

        query = with_identifier(params)
        query[:link] = link
        post("#{@resource}/link_request", params: query)
      end

      def remove_link_request(link:, **params)
        raise ArgumentError, "link is required" if link.to_s.empty?

        query = with_identifier(params)
        query[:link] = link
        delete("#{@resource}/link_request", params: query)
      end

      def add_track_request(link: nil, spotify_track_id: nil, isrc: nil, **params)
        if [link, spotify_track_id, isrc].all? { |value| value.to_s.empty? }
          raise ArgumentError, "One of link, spotify_track_id, or isrc is required"
        end

        query = with_identifier(params)
        query[:link] = link
        query[:spotify_track_id] = spotify_track_id
        query[:isrc] = isrc
        post("#{@resource}/track_request", params: query)
      end

      def remove_track_request(songstats_track_id: nil, spotify_track_id: nil, **params)
        if [songstats_track_id, spotify_track_id].all? { |value| value.to_s.empty? }
          raise ArgumentError, "songstats_track_id or spotify_track_id is required"
        end

        query = with_identifier(params)
        query[:songstats_track_id] = songstats_track_id
        query[:spotify_track_id] = spotify_track_id
        delete("#{@resource}/track_request", params: query)
      end

      def add_to_member_relevant_list(**params)
        post("#{@resource}/add_to_member_relevant_list", params: with_identifier(params))
      end

      def remove_from_member_relevant_list(**params)
        delete("#{@resource}/remove_from_member_relevant_list", params: with_identifier(params))
      end

      private

      def with_identifier(params)
        query = params.dup
        require_any_identifier!(query, @identifier_keys)
        query
      end
    end

    class Artists < Entity
      def initialize(http_client)
        super(
          http_client,
          resource: "artists",
          identifier_keys: %i[songstats_artist_id spotify_artist_id apple_music_artist_id]
        )
      end
    end

    class Collaborators < Entity
      def initialize(http_client)
        super(
          http_client,
          resource: "collaborators",
          identifier_keys: %i[songstats_collaborator_id spotify_artist_id apple_music_artist_id tidal_artist_id]
        )
      end
    end

    class Labels < Entity
      def initialize(http_client)
        super(
          http_client,
          resource: "labels",
          identifier_keys: %i[songstats_label_id beatport_label_id]
        )
      end
    end
  end
end
