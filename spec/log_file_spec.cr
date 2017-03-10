require "./spec_helper"

describe ApacheLogParser::LogFile do
  it "should return log file extension patterns" do
    ApacheLogParser::LogFile.ext_pattern.should eq "*{.gz}"
  end

  it "should return name" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src)
    log_file.name.should eq "access_log.gz"
  end 

  it "should yield each line" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src)
    rows = [] of ApacheLogParser::Row
    log_file.each_row do |row|
      rows << row
    end
    rows.size.should eq 30
    row = rows[25]
    row.true_client_ip.should eq "113.148.153.130"
    row.user_agent.should match /Mozilla\/5\.0/
  end

  it "should accept custom regex" do
    src = File.expand_path("../../samples/custom.log-20170310.gz", __FILE__)
    custom_re = %q{TCIP: "(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)"}
    log_file = ApacheLogParser::LogFile.new(src, custom_re)
    rows = [] of ApacheLogParser::Row
    log_file.each_row do |row|
      rows << row
    end
    rows.size.should eq 4
    row = rows.last
    row.true_client_ip.should eq "176.179.64.203"
    row.time.should eq Time.epoch(0)
  end
end
