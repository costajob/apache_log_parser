module ApacheLogParser
  module Filters
    abstract struct Base
      abstract def matches?(row)
    end

    struct TimeRange < Base
      TIME_FORMAT = "%F-%T%z"

      class InvalidTimeRangeError < Exception; end

      @from : Time
      @to : Time

      def initialize(from : String, to : String)
        @from = parse_time(from)
        @to = parse_time(to)
        check_time_range
      end

      def matches?(row)
        row.time >= @from && row.time <= @to
      end

      private def check_time_range
        raise InvalidTimeRangeError.new("#{@to} should be after #{@from}") if @to < @from
      end

      private def parse_time(time)
        Time.parse(time, TIME_FORMAT)
      end
    end

    struct Status < Base
      def initialize(@status : String)
      end

      def matches?(row)
        @status == row.status
      end
    end

    struct Keyword < Base
      def initialize(@keyword : String)
      end

      def matches?(row)
        row.request.match(/#{@keyword}/i)
      end
    end

    struct Verb < Base
      VERBS = %w[get post put delete head options]

      class InvalidVerbError < ArgumentError; end

      def initialize(@verb : String)
        check_verb
      end

      def matches?(row)
        @verb == fetch_verb(row)
      end

      private def check_verb
        raise InvalidVerbError.new("#{@verb} is not supported, use one of these: #{VERBS.join(", ")}") unless VERBS.includes?(@verb)
      end

      private def fetch_verb(row)
        row.request.match(/^(#{VERBS.join("|")})/i).try do |m|
          m[1].downcase
        end
      end
    end
  end
end
