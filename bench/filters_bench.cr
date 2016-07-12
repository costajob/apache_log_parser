require "./bench_helper.cr"

time_range = ApacheLogParser::Filters::TimeRange.new("2016-02-02-11:23:01+0200", "2016-02-02-11:23:03+0200")
row = Stubs.rows.first

Benchmark.ips do |x|
  x.report("#matches?") { time_range.matches?(Stubs.rows.first) }
  x.report("#includes?") { time_range.includes?(Stubs.rows.first) }
end
