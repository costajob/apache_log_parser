module ApacheLogParser
  module Filters
    abstract class Base
      TIME_FORMAT = ENV.fetch("TIME_FORMAT") { "%FT%T%z" }

      abstract def matches?(row)
    end

    class From < Base
      @from : Time

      def initialize(from : String)
        @from = Time.parse(from, TIME_FORMAT)
      end

      def matches?(row)
        row.time >= @from
      end
    end

    class To < Base
      @to : Time

      def initialize(to : String)
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
