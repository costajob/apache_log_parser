require "./spec_helper.cr"

describe ApacheLogParser::Scanner do
  it "should collect results by time range filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::TimeRange.new(from: "2016-07-03-04:56:24+0200", to: "2016-07-03-04:56:25+0200")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters, Stubs.regexs.first)
    scanner.call
    scanner.results["access_log.gz"].size.should eq 7
  end

  it "should collect results by HTTP status filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::Status.new("200")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters, Stubs.regexs.first)
    scanner.call
    scanner.results["access_log.gz"].size.should eq 7
  end

  it "should collect results by combining filters" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::TimeRange.new(from: "2016-07-03-04:56:22+0200", to: "2016-07-03-04:56:27+0200")
    filters << ApacheLogParser::Filters::Status.new("304")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters, Stubs.regexs.first)
    scanner.call
    scanner.results["access_log.gz"].size.should eq 11
  end
end
