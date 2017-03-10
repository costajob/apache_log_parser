require "gzip"
require "./row.cr"

module ApacheLogParser
  struct LogFile
    VALID_EXTENSIONS = %w(.gz)
    DEFAULT_REGEX = %q{\[(?<time>\d{2}\/\w{3}\/\d{4}:\d{2}:\d{2}:\d{2} [\+|-]\d{4})\] "(?<request>.+)" (?<status>\d{3}) .+"(?<user_agent>[Mozilla|Opera|ELinks|Links|Lynx]?.+)" .*?"(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)"}
    LOG_REGEX = ENV.fetch("LOG_REGEXP") { DEFAULT_REGEX }

    class InvalidFormatError < ArgumentError; end
    
    def self.ext_pattern
      String.build do |str|
        str << "*{"
        str << VALID_EXTENSIONS.join(",")
        str << "}"
      end
    end

    def initialize(@src : String, regex = LOG_REGEX)
      @regex = /#{regex}/
    end

    def name
      File.basename(@src)
    end

    def each_row
      File.open(@src, "r") do |src|
        Gzip::Reader.open(src) do |gz|
          gz.each_line do |line|
            data = line.match(@regex)
            raise InvalidFormatError.new("Invalid log file line format: #{line}") unless data
            yield(Row.new(data))
          end
        end
      end
    end
  end
end
