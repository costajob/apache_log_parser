require "./spec_helper.cr"

describe ApacheLogParser::Regex do
  it "should capture with default regex" do
    regex = ApacheLogParser::Regex.new
    rule = regex.call
    rule.should be_a(Regex)
    data = Stubs.lines[0].match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["status"].should eq "302"
    data["true_client_ip"].should eq "-"
    data["request"]?.should be_nil
    data["user_agent"]?.should be_nil
  end

  it "should capture user agent" do
    regex = ApacheLogParser::Regex.new(%w[UserAgent])
    rule = regex.call
    rule.should be_a(Regex)
    data = Stubs.lines[1].match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["user_agent"].should eq "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)"
    data["status"].should eq "304"
    data["true_client_ip"].should eq "211.157.178.224"
    data["request"]?.should be_nil
  end

  it "should capture request" do
    regex = ApacheLogParser::Regex.new(%w[Request])
    rule = regex.call
    rule.should be_a(Regex)
    data = Stubs.lines[2].match(rule).as(Regex::MatchData)
    data["time"].should eq "08/Mar/2017:00:00:22 +0000"
    data["request"].should eq "GET /us/en/customer/ajax/basic-info?key=1488931221858 HTTP/1.1"
    data["status"].should eq "302"
    data["true_client_ip"].should eq "192.40.127.248"
    data["user_agent"]?.should be_nil
  end

  it "should capture request by verb" do
    regex = ApacheLogParser::Regex.new(%w[Verb])
    rule = regex.call
    rule.should be_a(Regex)
    data = Stubs.lines[2].match(rule).as(Regex::MatchData)
    data["time"].should eq "08/Mar/2017:00:00:22 +0000"
    data["request"].should eq "GET /us/en/customer/ajax/basic-info?key=1488931221858 HTTP/1.1"
    data["status"].should eq "302"
    data["true_client_ip"].should eq "192.40.127.248"
    data["user_agent"]?.should be_nil
  end

  it "should capture all data" do
    regex = ApacheLogParser::Regex.new(%w[UserAgent Request])
    rule = regex.call
    rule.should be_a(Regex)
    data = Stubs.lines[3].match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:25 +0100"
    data["request"].should eq "HEAD /healthcheck.html HTTP/1.0"
    data["user_agent"].should eq "-"
    data["status"].should eq "200"
    data["true_client_ip"].should eq "-"
  end

  it "should fetch rule from environment variable" do
    custom = %q{^(?<client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)}
    regex = ApacheLogParser::Regex.new(%w[UserAgent Request])
    rule = regex.call(custom)
    rule.should be_a(Regex)
    data = Stubs.lines[0].match(rule).as(Regex::MatchData)
    data["client_ip"].should eq "23.63.227.241"
  end
end
