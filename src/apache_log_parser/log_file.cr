require "zlib"

module ApacheLogParser
  class LogFile
    def initialize(@src : String)
    end

    def name
      File.basename(@src)
    end

    def each_line
      File.open(@src, "r") do |src|
        Zlib::Inflate.gzip(src) do |gz|
          gz.each_line do |line|
            yield(line)
          end
        end
      end
    end
  end
end
