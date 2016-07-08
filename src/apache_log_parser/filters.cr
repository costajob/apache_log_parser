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
        (@from..@to).includes?(row.time)
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
  end
end
