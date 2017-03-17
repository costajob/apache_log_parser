require "./spec_helper.cr"

describe ApacheLogParser::Row do
  it "should create an instance by complete data" do
    data = {"time" => "03/Jul/2016:03:56:21 +0100", "request" => "\x93\x8c\x17", "status" => "304", "user_agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko", "true_client_ip" => "211.157.178.224"}
    row = ApacheLogParser::Row.new(data)
    row.should be_a ApacheLogParser::Row
    row.time.epoch.should eq 1467514581
    row.request.should eq "\x93\x8c\x17"
    row.status.should eq "304"
    row.user_agent.should eq "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"
    row.true_client_ip.should eq "211.157.178.224"
  end

  it "should create an instance with default values" do
    row = ApacheLogParser::Row.new({"noent" => "true"})
    row.should be_a ApacheLogParser::Row
    row.time.epoch.should eq 0
    row.request.should eq ""
    row.status.should eq ""
    row.user_agent.should eq ""
    row.true_client_ip.should eq ""
  end

  it "should be represented as a hash" do
    data = {"time" => "03/Jul/2016:03:56:21 +0100", "request" => "\x93\x8c\x17", "status" => "304", "user_agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko", "true_client_ip" => "211.157.178.224"}
    row = ApacheLogParser::Row.new(data)
    row.to_h.should eq({ time: row.time, request: "\x93\x8C\u0017", status: "304", user_agent: "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko", true_client_ip: "211.157.178.224"})
  end
end
