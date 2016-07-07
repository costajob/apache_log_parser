require "./spec_helper"

describe ApacheLogParser::LogFile do
  it "should return name" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src, Stubs.formats.last)
    log_file.name.should eq "access_log.gz"
  end 

  it "should yeald each line" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src, Stubs.formats.last)
    rows = [] of ApacheLogParser::Row
    log_file.each_row do |row|
      rows << row
    end
    rows.size.should eq 23
    rows[3].true_client_ip.should eq "126.245.6.49"
  end
end
