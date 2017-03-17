require "./spec_helper.cr"

describe ApacheLogParser::Scanner do
  it "should collect results from time filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::From.new("2016-07-03T04:56:24+0200")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [24]
  end

  it "should collect results till time filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::To.new("2016-07-03T04:56:25+0200")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [13]
  end

  it "should collect results by HTTP status filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::Status.new("20*")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [11]
  end

  it "should collect results by true client IP filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::TrueClientIP.new("221.127.193.144")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [4]
  end

  it "should collect results by HTTP verb filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::Verb.new("head")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [1]
  end

  it "should collect results by request filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::Request.new("jpg")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [16]
  end

  it "should collect results by user agent filter" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::UserAgent.new("iphone")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [9]
  end

  it "should collect results by combining filters" do
    filters = [] of ApacheLogParser::Filters::Base
    filters << ApacheLogParser::Filters::From.new("2016-07-03T04:56:22+0200")
    filters << ApacheLogParser::Filters::To.new("2016-07-03T04:56:27+0200")
    filters << ApacheLogParser::Filters::Status.new("304")
    filters << ApacheLogParser::Filters::Verb.new("get")
    filters << ApacheLogParser::Filters::Request.new("jpg")
    filters << ApacheLogParser::Filters::UserAgent.new("iphone")
    scanner = ApacheLogParser::Scanner.new(Stubs::DEFAULT_PATH, filters)
    scanner.call(Stubs::Report).should eq [6]
  end
end
