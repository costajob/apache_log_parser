require "benchmark"
require "./spec_helper.cr"

describe ApacheLogParser::Filters do
  context ApacheLogParser::Filters::TimeRange do
    it "should raise an error for invalid ranges" do
      expect_raises(ApacheLogParser::Filters::TimeRange::InvalidTimeRangeError) do
        ApacheLogParser::Filters::TimeRange.new(from: "2016-02-02T11:23:01+0100", to: "2016-02-02T11:13:01+0100")
      end
    end

    it "should match row by time range" do
      filter = ApacheLogParser::Filters::TimeRange.new(from: "2016-02-02T11:23:00+0000", to: "2016-02-02T11:33:01+0000")
      filter.matches?(Stubs.rows[0]).should be_true
    end
  end

  context ApacheLogParser::Filters::Status do
    it "should match row by HTTP status" do
      filter = ApacheLogParser::Filters::Status.new("201")
      filter.matches?(Stubs.rows[0]).should be_true
    end
  end

  context ApacheLogParser::Filters::Keyword do
    it "should match row by keyword" do
      filter = ApacheLogParser::Filters::Keyword.new("healthcheck")
      filter.matches?(Stubs.rows[0]).should be_falsey
      filter.matches?(Stubs.rows[1]).should be_truthy
    end
  end

  context ApacheLogParser::Filters::UserAgent do
    it "should match row by user agent" do
      filter = ApacheLogParser::Filters::UserAgent.new("iphone")
      filter.matches?(Stubs.rows[0]).should be_truthy
      filter.matches?(Stubs.rows[1]).should be_falsey
    end
  end

  context ApacheLogParser::Filters::Verb do
    it "should raise an error for invalid verb" do
      expect_raises(ApacheLogParser::Filters::Verb::InvalidVerbError) do
        ApacheLogParser::Filters::Verb.new("noent")
      end
    end

    it "should match row by HTTP status" do
      filter = ApacheLogParser::Filters::Verb.new("head")
      filter.matches?(Stubs.rows[1]).should be_true
    end
  end
end
