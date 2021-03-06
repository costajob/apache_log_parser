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
          str << "apache_log_parser -s /logs -f 2016-06-30T00:00:00+0100 -t 2016-07-04T00:00:00+0100 -i 66.249.66.63 -c 20* -r send_mail -a iphone".colorize(:light_gray).bold
        end

        parser.on("-s SRC", "--src=SRC", "Specify log files path [cwd]") do |src| 
          @src = src
        end
        
        parser.on("-f FROM", "--from=FROM", "Filter requests from this time") do |from|
          @filters << Filters::From.new(from)
        end

        parser.on("-t TO", "--to=TO", "Filter requests until this time") do |to|
          @filters << Filters::To.new(to)
        end

        parser.on("-c CODE", "--code=CODE", "Filter HTTP code by regex") do |code|
          @filters << Filters::Status.new(code)
        end

        parser.on("-i IPS", "--ips=IPS", "Filter by list of true client IPs") do |ips|
          @filters << Filters::TrueClientIP.new(ips)
        end

        parser.on("-r REQUEST", "--request=REQUEST", "Filter HTTP request by regex") do |request|
          @filters << Filters::Request.new(request)
        end

        parser.on("-a AGENT", "--agent=AGENT", "Filter user agent by regex") do |agent|
          @filters << Filters::UserAgent.new(agent)
        end

        parser.on("-h", "--help", "Show this help") { puts parser }
      end
    end
  end
end

ApacheLogParser::Main.new.call
