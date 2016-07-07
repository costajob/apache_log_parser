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
      Scanner.new(@src, @filters).call(STDOUT)
    end

    private def setup
      OptionParser.parse! do |parser|
        parser.banner = "Usage: ./apache_log_parser --src=./samples --from=2016-07-03-03:56:24+0100 --to=2016-07-03-03:56:27+0100 --code=201 --agent=iphone"

        parser.on("-s SRC", "--src=SRC", "Specify log files path (default to CWD)") do |src| 
          @src = src
        end
        
        parser.on("-f FROM", "--from=FROM", "Filter requests since this time") do |from|
          @from = from
        end

        parser.on("-t TO", "--to=TO", "Filter requests until this time") do |to|
          @to = to
        end

        parser.on("-c CODE", "--code=CODE", "Filter by HTTP code") do |code|
          @filters << Filters::Status.new(code)
        end

        parser.on("-a AGENT", "--agent=AGENT", "Filter by user agent status") do |agent|
          @filters << Filters::UserAgent.new(agent)
        end

        parser.on("-h", "--help", "Show this help") { puts parser }
      end

      @filters << Filters::TimeRange.new(@from.as(String), @to.as(String)) if @from && @to
    end
  end
end

ApacheLogParser::Main.new.call
