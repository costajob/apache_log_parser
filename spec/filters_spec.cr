require "./spec_helper.cr"

describe ApacheLogParser::Filters do
  context ApacheLogParser::Filters::From do
    it "should match row starting from" do
      filter = ApacheLogParser::Filters::From.new("2006-02-02T11:23:00+0000")
      filter.matches?(Stubs.rows[0]).should be_true
    end

    it "should not match future times" do
      filter = ApacheLogParser::Filters::From.new("2036-02-02T11:23:00+0000")
      filter.matches?(Stubs.rows[0]).should be_false
    end
  end

  context ApacheLogParser::Filters::To do
    it "should match row ending to" do
      filter = ApacheLogParser::Filters::To.new("2036-02-02T11:33:01+0000")
      filter.matches?(Stubs.rows[0]).should be_true
    end

    it "should not match past times" do
      filter = ApacheLogParser::Filters::To.new("2006-02-02T11:23:00+0000")
      filter.matches?(Stubs.rows[0]).should be_false
    end
  end

  context ApacheLogParser::Filters::Status do
    it "should match row by HTTP status" do
      filter = ApacheLogParser::Filters::Status.new("201")
      filter.matches?(Stubs.rows[0]).should be_truthy
    end

    it "should match row by excluding HTTP status" do
      filter = ApacheLogParser::Filters::Status.new("-201")
      filter.matches?(Stubs.rows[0]).should be_falsey
      filter.matches?(Stubs.rows[1]).should be_truthy
    end
  end

  context ApacheLogParser::Filters::TrueClientIP do
    it "should match row by true client IP" do
      filter = ApacheLogParser::Filters::TrueClientIP.new("211.157.178.224")
      filter.matches?(Stubs.rows[0]).should be_truthy
    end
  end

  context ApacheLogParser::Filters::Request do
    it "should match row by keyword" do
      filter = ApacheLogParser::Filters::Request.new("healthcheck")
      filter.matches?(Stubs.rows[0]).should be_falsey
      filter.matches?(Stubs.rows[1]).should be_truthy
    end

    it "should match row by excluding keyword" do
      filter = ApacheLogParser::Filters::Request.new("-healthcheck")
      filter.matches?(Stubs.rows[0]).should be_truthy
      filter.matches?(Stubs.rows[1]).should be_falsey
    end
  end

  context ApacheLogParser::Filters::UserAgent do
    it "should match row by user agent" do
      filter = ApacheLogParser::Filters::UserAgent.new("iphone")
      filter.matches?(Stubs.rows[0]).should be_truthy
      filter.matches?(Stubs.rows[1]).should be_falsey
    end

    it "should match row by excluding user agent" do
      filter = ApacheLogParser::Filters::UserAgent.new("-iphone")
      filter.matches?(Stubs.rows[0]).should be_falsey
      filter.matches?(Stubs.rows[1]).should be_truthy
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
