require "./filters.cr"
require "./log_file.cr"
require "./report.cr"

module ApacheLogParser
  class Scanner
    DEFAULT_FORMAT = %(%h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-Agent}i" "%{True-Client-IP}i")

    getter :results

    @regex : Regex

    def initialize(@path : String, @filters : Array(Filters::Base), format = DEFAULT_FORMAT)
      @regex = Format.new(format).regex
      @results = Hash(String, Array(Row)).new do |h, k|
        h[k] = [] of Row
      end
    end

    def call(output = MemoryIO.new)
      log_files.each do |log_file|
        log_file.each_row do |row|
          @results[log_file.name] << row if @filters.all? { |filter| filter.matches?(row) }
        end
        Report.new(log_file.name).render(@results[log_file.name], output)
      end
    end

    private def log_files
      Dir["#{@path}/#{LogFile.ext_pattern}"].map { |src| LogFile.new(src, @regex) }
    end
  end
end
