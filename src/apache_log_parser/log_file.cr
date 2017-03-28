require "gzip"
require "./row.cr"

module ApacheLogParser
  struct LogFile
    VALID_EXTENSIONS = %w(.gz)

    def self.ext_pattern
      String.build do |str|
        str << "*{"
        str << VALID_EXTENSIONS.join(",")
        str << "}"
      end
    end

    @regex : ::Regex

    def initialize(@src : String, regex_obj)
      @regex = regex_obj.call
    end

    def name
      File.basename(@src)
    end

    def each_row
      File.open(@src, "r") do |src|
        Gzip::Reader.open(src) do |gz|
          gz.each_line do |line|
            data = line.match(@regex)
            next unless data
            yield(Row.new(data))
          end
        end
      end
    end
  end
end
