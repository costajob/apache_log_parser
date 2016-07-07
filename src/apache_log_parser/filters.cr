module ApacheLogParser
  module Filters
    abstract struct Base
      abstract def matches?(row)
    end

    struct TimeRange < Base
      TIME_FORMAT = "%F-%T"

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
      @status : Int32

      def initialize(status : String)
        @status = status.to_i
      end

      def matches?(row)
        @status == row.status
      end
    end

    struct UserAgent < Base
      def initialize(@user_agent : String)
      end

      def matches?(row)
        row.user_agent.match(/\b#{@user_agent}/i)
      end
    end
  end
end
