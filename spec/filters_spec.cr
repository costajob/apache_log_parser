require "./spec_helper.cr"

describe ApacheLogParser::Filters do
  context ApacheLogParser::Filters::TimeRange do
    it "should raise an error for invalid ranges" do
      expect_raises(ApacheLogParser::Filters::TimeRange::InvalidTimeRangeError) do
        ApacheLogParser::Filters::TimeRange.new(from: "2016-02-02-11:23:01+0100", to: "2016-02-02-11:13:01+0100")
      end
    end

    it "should match row by time range" do
      filter = ApacheLogParser::Filters::TimeRange.new(from: "2016-02-02-11:23:01+0100", to: "2016-02-02-11:33:01+0100")
      filter.matches?(Stubs.rows[0])
    end
  end

  context ApacheLogParser::Filters::Status do
    it "should match row by HTTP status" do
      filter = ApacheLogParser::Filters::Status.new("201")
      filter.matches?(Stubs.rows[0])
    end
  end

  context ApacheLogParser::Filters::UserAgent do
    it "should match row by user agent" do
      filter = ApacheLogParser::Filters::UserAgent.new("iphone")
      filter.matches?(Stubs.rows[0])
    end
  end
end
