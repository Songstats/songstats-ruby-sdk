# frozen_string_literal: true

module SongstatsSDK
  module Resources
    class Tracks < Base
      IDENTIFIER_KEYS = %i[songstats_track_id spotify_track_id apple_music_track_id isrc].freeze

      def info(**params)
        get("tracks/info", params: with_identifier(params))
      end

      def stats(**params)
        get("tracks/stats", params: with_identifier(params))
      end

      def historic_stats(**params)
        get("tracks/historic_stats", params: with_identifier(params))
      end

      def activities(**params)
        get("tracks/activities", params: with_identifier(params))
      end

      def comments(**params)
        get("tracks/comments", params: with_identifier(params))
      end

      def songshare(**params)
        get("tracks/songshare", params: with_identifier(params))
      end

      def locations(**params)
        get("tracks/locations", params: with_identifier(params))
      end

      def search(q:, **params)
        raise ArgumentError, "q is required" if q.to_s.empty?

        get("tracks/search", params: params.merge(q: q))
      end

      def add_link_request(link:, **params)
        raise ArgumentError, "link is required" if link.to_s.empty?

        query = with_identifier(params)
        query[:link] = link
        post("tracks/link_request", params: query)
      end

      def remove_link_request(link:, **params)
        raise ArgumentError, "link is required" if link.to_s.empty?

        query = with_identifier(params)
        query[:link] = link
        delete("tracks/link_request", params: query)
      end

      def add_to_member_relevant_list(**params)
        post("tracks/add_to_member_relevant_list", params: with_identifier(params))
      end

      def remove_from_member_relevant_list(**params)
        delete("tracks/remove_from_member_relevant_list", params: with_identifier(params))
      end

      private

      def with_identifier(params)
        query = params.dup
        require_any_identifier!(query, IDENTIFIER_KEYS)
        query
      end
    end
  end
end
