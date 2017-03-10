require "./spec_helper.cr"

describe ApacheLogParser::Scanner do
  it "should collect results by time range filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::TimeRange.new(from: "2016-07-03T04:56:24+0200", to: "2016-07-03T04:56:25+0200")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call.should eq [7,0]
  end

  it "should collect results by HTTP status filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::Status.new("200")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call.should eq [10,3]
  end

  it "should collect results by HTTP verb filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::Verb.new("head")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call.should eq [1,0]
  end

  it "should collect results by request filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::Request.new("jpg")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call.should eq [16,0]
  end

  it "should collect results by user agent filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::UserAgent.new("iphone")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call.should eq [9,3]
  end

  it "should collect results by combining filters" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::TimeRange.new(from: "2016-07-03T04:56:22+0200", to: "2016-07-03T04:56:27+0200")
    filters << ApacheLogParser::Filters::Status.new("304")
    filters << ApacheLogParser::Filters::Verb.new("get")
    filters << ApacheLogParser::Filters::Request.new("jpg")
    filters << ApacheLogParser::Filters::UserAgent.new("iphone")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call.should eq [6,0]
  end
end
