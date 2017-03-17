require "option_parser"
require "colorize"
require "./apache_log_parser/*"

module ApacheLogParser
  class Main
    @from : String?
    @to : String?

    def initialize
      @filters = [] of Filters::Base
      @src = File.expand_path(".")
    end

    def call
      setup
      Scanner.new(@src, @filters).call
    end

    private def setup
      OptionParser.parse! do |parser|
        parser.banner = String.build do |str|
          str << "Usage: "
          str << "./apache_log_parser -s /logs -f 2016-06-30T00:00:00+0100 -t 2016-07-04T00:00:00+0100 -i 66.249.66.63 -c 20* -k send_mail -a iphone -v get".colorize(:light_gray).bold
        end

        parser.on("-s SRC", "--src=SRC", "Specify log files path [cwd]") do |src| 
          @src = src
        end
        
        parser.on("-f FROM", "--from=FROM", "Filter requests from this time") do |from|
          @from = from
        end

        parser.on("-t TO", "--to=TO", "Filter requests until this time") do |to|
          @to = to
        end

        parser.on("-c CODE", "--code=CODE", "Filter by HTTP code") do |code|
          @filters << Filters::Status.new(code)
        end

        parser.on("-i IP", "--ip=IP", "Filter by true client IP") do |ip|
          @filters << Filters::TrueClientIP.new(ip)
        end

        parser.on("-r REQUEST", "--request=REQUEST", "Filter HTTP request by regex") do |request|
          @filters << Filters::Request.new(request)
        end

        parser.on("-a AGENT", "--agent=AGENT", "Filter user agent by regex") do |agent|
          @filters << Filters::UserAgent.new(agent)
        end

        parser.on("-v VERB", "--verb=VERB", "Filter by HTTP verb") do |verb|
          @filters << Filters::Verb.new(verb)
        end

        parser.on("-h", "--help", "Show this help") { puts parser }
      end

      @filters << Filters::TimeRange.new(@from.as(String), @to.as(String)) if @from && @to
    end
  end
end

ApacheLogParser::Main.new.call
