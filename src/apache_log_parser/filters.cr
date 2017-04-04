module ApacheLogParser
  module Filters
    TIME_FORMAT = ENV.fetch("TIME_FORMAT") { "%FT%T%z" }
    TIME_REGEX = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{4}/

    class InvalidTimeFormatError < ArgumentError; end

    abstract class Base
      abstract def matches?(row)

      def check_format(time)
        return true if time.match(TIME_REGEX)
        raise InvalidTimeFormatError.new("invalid time format #{time}, use: 1973-10-29T23:10:59+0000")
      end
    end

    class From < Base
      @from : Time

      def initialize(from : String)
        check_format(from)
        @from = Time.parse(from, TIME_FORMAT)
      end

      def matches?(row)
        row.time >= @from
      end
    end

    class To < Base
      @to : Time

      def initialize(to : String)
        check_format(to)
        @to = Time.parse(to, TIME_FORMAT)
      end

      def matches?(row)
        row.time <= @to
      end
    end

    class TrueClientIP < Base
      @ips : Array(String)

      def initialize(ips : String)
        @ips = ips.split(",").map(&.strip)
      end

      def matches?(row)
        @ips.includes?(row.true_client_ip)
      end
    end

    class Status < Base
      def initialize(status : String)
        @negate = !!status.match(/^-/)
        @regex = /#{status.sub(/^-/, "")}/
      end

      def matches?(row)
        return !row.status.match(@regex) if @negate
        row.status.match(@regex)
      end
    end

    class Request < Base
      def initialize(request : String)
        @negate = !!request.match(/^-/)
        @regex = /#{request.sub(/^-/, "")}/i
      end

      def matches?(row)
        return !row.request.match(@regex) if @negate
        row.request.match(@regex)
      end
    end

    class UserAgent < Base
      def initialize(user_agent : String)
        @negate = !!user_agent.match(/^-/)
        @regex = /#{user_agent.sub(/^-/, "")}/i
      end

      def matches?(row)
        return !row.user_agent.match(@regex) if @negate
        row.user_agent.match(@regex)
      end
    end
  end
end
