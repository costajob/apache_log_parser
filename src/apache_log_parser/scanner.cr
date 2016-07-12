require "./filters.cr"
require "./log_file.cr"
require "./report.cr"

module ApacheLogParser
  class Scanner
    def initialize(@path : String, @filters : Array(Filters::Base), @regex : Regex)
    end

    def call(output = MemoryIO.new)
      log_files.map do |log_file|
        filtered = [] of Row
        log_file.each_row do |row|
          filtered << row if @filters.all? { |filter| filter.matches?(row) }
        end
        Report.new(log_file.name).render(filtered, output)
        filtered.size
      end
    end

    private def log_files
      Dir["#{@path}/#{LogFile.ext_pattern}"].map { |src| LogFile.new(src, @regex) }
    end
  end
end
