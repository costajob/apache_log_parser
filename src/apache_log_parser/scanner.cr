require "./filters.cr"
require "./log_file.cr"
require "./report.cr"
require "./regex.cr"
require "./prompt.cr"

module ApacheLogParser
  class Scanner
    def initialize(@path : String, @filters : Array(Filters::Base)); end

    def call(report_klass = Report, regex_klass = Regex)
      log_files(regex_klass).map do |log_file|
        filtered = [] of Row
        log_file.each_row do |row|
          filtered << row if @filters.all? { |filter| filter.matches?(row) }
        end
        report = report_klass.new(log_file.name)
        report.render(filtered)
        report_klass.ask("Create CSV export") do
          report.to_csv(filtered)
        end
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
