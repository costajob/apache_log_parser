module ApacheLogParser
  module Filters
    abstract class Base
      abstract def matches?(row)
    end

    class TimeRange < Base
      TIME_FORMAT = ENV.fetch("TIME_FORMAT") { "%FT%T%z" }

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

    class TrueClientIP < Base
      def initialize(ip : String)
        @ip = ip
      end

      def matches?(row)
        row.true_client_ip == @ip
      end
    end

    class Status < Base
      def initialize(status : String)
        @status = /#{status}/
      end

      def matches?(row)
        row.status.match(@status)
      end
    end

    class Request < Base
      def initialize(request : String)
        @request = /#{request}/i
      end

      def matches?(row)
        row.request.match(@request)
      end
    end

    class UserAgent < Base
      def initialize(user_agent : String)
        @user_agent = /#{user_agent}/i
      end

      def matches?(row)
        row.user_agent.match(@user_agent)
      end
    end

    class Verb < Base
      VERBS = %w[get post put delete head options]
      VERBS_REGEX = /^(#{VERBS.join("|")})/i

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
        row.request.match(VERBS_REGEX).try { |m| m[1].downcase }
      end
    end
  end
end
