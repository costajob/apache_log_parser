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

  it "should yeald each line" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src)
    rows = [] of ApacheLogParser::Row
    log_file.each_row do |row|
      rows << row
    end
    rows.size.should eq 28
    rows[25].true_client_ip.should eq "113.148.153.130"
  end
end
