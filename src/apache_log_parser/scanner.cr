require "./filters.cr"
require "./log_file.cr"
require "./report.cr"
require "./regex.cr"

module ApacheLogParser
  class Scanner
    def initialize(@path : String, @filters : Array(Filters::Base)); end

    def call(output = IO::Memory.new, regex_klass = Regex)
      log_files(regex_klass).map do |log_file|
        filtered = [] of Row
        log_file.each_row do |row|
          filtered << row if @filters.all? { |filter| filter.matches?(row) }
        end
        Report.new(log_file.name).render(filtered, output)
        filtered.size
      end
    end

    private def log_files(regex_klass)
      regex = regex_klass.new(filter_names)
      Dir["#{@path}/#{LogFile.ext_pattern}"].map { |src| LogFile.new(src, regex) }
    end

    private def filter_names
      @filters.map do |filter|
        filter.class.to_s.split("::").last
      end
    end
  end
end
