require "option_parser"
require "./apache_log_parser/*"

module ApacheLogParser
  class Main

    @from : String?
    @to : String?

    def initialize
      @filters = [] of Filters::Base
      @src = "./"
    end

    def call
      setup
      return if @filters.empty?
      Scanner.new(filters: @filters, path: @src).call(STDOUT)
    end

    private def setup
      OptionParser.parse! do |parser|
        parser.banner = "Usage: ./apache_log_parser -s ./samples -f 2016-07-03-04:56:24 -t 2016-07-03-04:56:27 -h 201 -a iphone"

        parser.on("-s SRC", "--src=SRC", "Specify log files path (default to CWD)") do |src| 
          @src = src
        end
        
        parser.on("-f FROM", "--from=FROM", "Filter requests since this time") do |from|
          @from = from
        end

        parser.on("-t TO", "--to=TO", "Filter requests until this time") do |to|
          @to = to
        end

        if @from && @to
          @filters << Filters::TimeRange.new(@from.as(String), @to.as(String))
        end

        parser.on("-h STATUS", "--http_status=STATUS", "Filter by HTTP status") do |status|
          @filters << Filters::Status.new(status)
        end

        parser.on("-a AGENT", "--agent=AGENT", "Filter by user agent status") do |agent|
          @filters << Filters::UserAgent.new(agent)
        end

        parser.on("-h", "--help", "Show this help") { puts parser }
      end
    end
  end
end

ApacheLogParser::Main.new.call
