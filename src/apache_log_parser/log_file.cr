require "zlib"
require "./row.cr"

module ApacheLogParser
  struct LogFile
    VALID_EXTENSIONS = %w(.gz)

    DEFAULT_REGEX = /(?<host>(?:[0-9]{1,3}\.){3}[0-9]{1,3}) (?<logname>\w+|-) (?<user>\w+|-) \[(?<time>.+)\] "(?<request>.+?|.?)" (?<status>\b\d{3}\b) (?<bytes>\w+|-) "(?<referer>.+?|.?)" "(?<user_agent>.+?|.?)" "(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)"/

    class InvalidFormatError < ArgumentError; end
    
    def self.ext_pattern
      String.build do |str|
        str << "*{"
        str << VALID_EXTENSIONS.join(",")
        str << "}"
      end
    end

    def initialize(@src : String, @regex = DEFAULT_REGEX)
    end

    def name
      File.basename(@src)
    end

    def each_row
      File.open(@src, "r") do |src|
        Zlib::Inflate.gzip(src) do |gz|
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
