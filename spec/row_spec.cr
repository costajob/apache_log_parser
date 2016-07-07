require "./spec_helper.cr"

describe ApacheLogParser::Row do
  it "should factory an instance by complete data" do
    data = {"host" => "23.216.10.10", "logname" => "-", "user" => "-", "time" => "03/Jul/2016:03:56:21 +0100", "request" => "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1", "status": "304", "bytes": "-", "referer": "http://www-m.gucci.com/cn/styles/400249CEMMN5609", "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)", "true_client_ip" => "211.157.178.224", "server_name" => "localhost"}
    row = ApacheLogParser::Row.factory(data)
    row.should be_a ApacheLogParser::Row
  end

  it "should factory an instance by partial data" do
    row = ApacheLogParser::Row.factory({"host" => "21.216.10.10"})
    row.should be_a ApacheLogParser::Row
  end

  it "should factory an instance by default values" do
    row = ApacheLogParser::Row.factory({"host" => "21.216.10.10", "bytes" => "-"})
    row.should be_a ApacheLogParser::Row
    row.host.should eq "21.216.10.10"
    row.time.epoch.should eq 0
    row.status.should eq 0
    row.bytes.should eq 0
    row.true_client_ip.should eq ""
  end

  it "should parse time value" do
    row = ApacheLogParser::Row.factory({"time" => "03/Jul/2016:03:56:21 +0100"})
    row.time.should be_a Time
    row.time.epoch.should eq 1467514581
  end

  it "should set status as an integer" do
    row = ApacheLogParser::Row.factory({"status" => "201"})
    row.status.should eq 201
  end

  it "should set bytes as an integer" do
    row = ApacheLogParser::Row.factory({"bytes" => "512"})
    row.bytes.should eq 512
  end
end
