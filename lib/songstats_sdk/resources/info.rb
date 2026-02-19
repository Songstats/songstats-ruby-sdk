# frozen_string_literal: true

module SongstatsSDK
  module Resources
    class Info < Base
      def sources
        get("sources")
      end

      def status
        get("status")
      end

      def uptime_check
        get("uptime_check")
      end

      def definitions
        get("definitions")
      end
    end
  end
end
