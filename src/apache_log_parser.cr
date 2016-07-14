require "option_parser"
require "colorize"
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
        parser.banner = String.build do |str|
          str << "Usage: "
          str << "./apache_log_parser -s /logs -f 2016-06-30-00:00:00+0100 -t 2016-07-04-00:00:00+0100 -c 200 -k send_mail -v get".colorize(:light_gray).bold
        end

        parser.on("-s SRC", "--src=SRC", "Specify log files path (default to CWD)") do |src| 
          @src = src
        end
        
        parser.on("-f FROM", "--from=FROM", "Filter requests starting at this time") do |from|
          @from = from
        end

        parser.on("-t TO", "--to=TO", "Filter requests ending at this time") do |to|
          @to = to
        end

        parser.on("-c CODE", "--code=CODE", "Filter by HTTP code") do |code|
          @filters << Filters::Status.new(code)
        end

        parser.on("-k KEYWORD", "--keyword=KEYWORD", "Filter HTTP request by keyword") do |keyword|
          @filters << Filters::Keyword.new(keyword)
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
