require "./spec_helper.cr"

describe ApacheLogParser::Row do
  it "should create an instance by complete data" do
    data = {"time" => "03/Jul/2016:03:56:21 +0100", "request" => "\x93\x8c\x17", "status" => "304", "true_client_ip" => "211.157.178.224"}
    row = ApacheLogParser::Row.new(data)
    row.should be_a ApacheLogParser::Row
    row.time.epoch.should eq 1467514581
    row.request.should eq "\x93\x8c\x17"
    row.status.should eq "304"
    row.true_client_ip.should eq "211.157.178.224"
  end

  it "should create an instance with default values" do
    row = ApacheLogParser::Row.new({"noent" => "true"})
    row.should be_a ApacheLogParser::Row
    row.time.epoch.should eq 0
    row.request.should eq "-"
    row.status.should eq "-"
    row.true_client_ip.should eq "-"
  end
end
