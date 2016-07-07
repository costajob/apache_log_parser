require "zlib"
require "./format.cr"
require "./row.cr"

module ApacheLogParser
  class LogFile
    VALID_EXTENSIONS = %w(.gz)
    
    def self.ext_pattern
      String.build do |str|
        str << "*{"
        str << VALID_EXTENSIONS.join(",")
        str << "}"
      end
    end

    def initialize(@src : String, @regex : Regex)
    end

    def name
      File.basename(@src)
    end

    def each_row
      File.open(@src, "r") do |src|
        Zlib::Inflate.gzip(src) do |gz|
          gz.each_line do |line|
            data = line.match(@regex).as(Regex::MatchData)
            row = Row.factory(data)
            yield(row)
          end
        end
      end
    end
  end
end
