require "zlib"
require "./format.cr"
require "./row.cr"

module ApacheLogParser
  class LogFile
    def initialize(@src : String, format : String)
      @format = Format.new(format)
    end

    def name
      File.basename(@src)
    end

    def each_row
      File.open(@src, "r") do |src|
        Zlib::Inflate.gzip(src) do |gz|
          gz.each_line do |line|
            data = line.match(@format.regex).as(Regex::MatchData)
            row = Row.factory(data)
            yield(row)
          end
        end
      end
    end
  end
end
