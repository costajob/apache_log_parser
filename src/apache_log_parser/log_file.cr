require "zlib"
require "./format.cr"

module ApacheLogParser
  class LogFile
    def initialize(@src : String, format : String)
      @format = Format.new(format)
    end

    def name
      File.basename(@src)
    end

    def each_line
      File.open(@src, "r") do |src|
        Zlib::Inflate.gzip(src) do |gz|
          gz.each_line do |line|
            yield(matchings(line))
          end
        end
      end
    end

    private def matchings(line)
      line.match(@format.regex)
    end
  end
end
