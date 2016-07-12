require "./spec_helper.cr"

describe ApacheLogParser::Row do
  it "should create an instance by complete data" do
    data = {"host" => "23.216.10.10", "logname" => "-", "user" => "-", "time" => "03/Jul/2016:03:56:21 +0100", "request" => "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1", "status" => "304", "bytes" => "-", "referer" => "http://www-m.gucci.com/cn/styles/400249CEMMN5609", "user_agent" => "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)", "true_client_ip" => "211.157.178.224", "server_name" => "localhost"}
    row = ApacheLogParser::Row.new(data)
    row.should be_a ApacheLogParser::Row
    row.host.should eq "23.216.10.10"
    row.time.epoch.should eq 1467514581
    row.logname.should eq "-"
    row.user.should eq "-"
    row.request.should eq "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1"
    row.status.should eq "304"
    row.bytes.should eq "-"
    row.referer.should eq "http://www-m.gucci.com/cn/styles/400249CEMMN5609"
    row.user_agent.should eq "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)"
    row.true_client_ip.should eq "211.157.178.224"
    row.server_name.should eq "localhost"
    row.verb.should eq "get"
  end

  it "should create an instance with default values" do
    row = ApacheLogParser::Row.new({"host" => "21.216.10.10"})
    row.should be_a ApacheLogParser::Row
    row.host.should eq "21.216.10.10"
    row.time.epoch.should eq 0
    row.logname.should eq "-"
    row.user.should eq "-"
    row.request.should eq "-"
    row.status.should eq "-"
    row.bytes.should eq "-"
    row.referer.should eq "-"
    row.user_agent.should eq "-"
    row.true_client_ip.should eq "-"
    row.server_name.should eq "-"
    row.verb.should eq "-"
  end
end
