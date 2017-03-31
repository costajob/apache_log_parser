require "./spec_helper.cr"

describe ApacheLogParser::Regex do
  it "should remove status, request and user agent regexs" do
    regex = ApacheLogParser::Regex.new
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
  end

  it "should remove status and user agent regex" do
    regex = ApacheLogParser::Regex.new(%w[Request])
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
    data["request"].should eq "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1"
  end

  it "should remove request and user agent regexs" do
    regex = ApacheLogParser::Regex.new(%w[Status])
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
    data["status"].should eq "304"
  end

  it "should remove request and status regexs" do
    regex = ApacheLogParser::Regex.new(%w[UserAgent])
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
    data["user_agent"].should eq "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)"
  end

  it "should remove user agent regex" do
    regex = ApacheLogParser::Regex.new(%w[Request Status])
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
    data["request"].should eq "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1"
    data["status"].should eq "304"
  end

  it "should remove status regex" do
    regex = ApacheLogParser::Regex.new(%w[Request UserAgent])
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
    data["request"].should eq "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1"
    data["user_agent"].should eq "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)"
  end

  it "should remove request regex" do
    regex = ApacheLogParser::Regex.new(%w[Status UserAgent])
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
    data["status"].should eq "304"
    data["user_agent"].should eq "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)"
  end

  it "should remove no regexs" do
    regex = ApacheLogParser::Regex.new(%w[Request Status UserAgent])
    rule = regex.call
    data = Stubs.line.match(rule).as(Regex::MatchData)
    data["time"].should eq "03/Jul/2016:03:56:21 +0100"
    data["true_client_ip"].should eq "211.157.178.224"
    data["request"].should eq "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1"
    data["status"].should eq "304"
    data["user_agent"].should eq "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)"
  end

  it "should detect data for request triggered by agents" do
    line = %q[184.26.93.175 - - [26/Mar/2017:00:00:34 +0000] "GET /_ui/responsive/akamai/akamai-test-object.html HTTP/1.1" 200 2888 "-" "-" TCIP: "127.0.0.1" "-" 3050]
    regex = ApacheLogParser::Regex.new(%w[Status Request UserAgent])
    rule = regex.call
    data = line.match(rule).as(Regex::MatchData)
    data["time"].should eq "26/Mar/2017:00:00:34 +0000"
    data["true_client_ip"].should eq "127.0.0.1"
    data["request"].should eq "GET /_ui/responsive/akamai/akamai-test-object.html HTTP/1.1"
    data["status"].should eq "200"
    data["user_agent"].should eq "-"
  end
end
