# frozen_string_literal: true

module SongstatsSDK
  module Resources
    class Albums < Base
      def info(**params)
        get("albums/info", params: with_identifier(params))
      end

      def stats(**params)
        get("albums/stats", params: with_identifier(params))
      end

      private

      def with_identifier(params)
        require_any_identifier!(params, %i[songstats_album_id spotify_album_id apple_music_album_id amazon_album_id
          deezer_album_id beatport_album_id traxsource_album_id tidal_album_id qobuz_album_id])
        params.dup
      end
    end
  end
end
