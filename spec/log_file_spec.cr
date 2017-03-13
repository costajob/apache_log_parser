require "./spec_helper"

describe ApacheLogParser::LogFile do
  it "should return log file extension patterns" do
    ApacheLogParser::LogFile.ext_pattern.should eq "*{.gz}"
  end

  it "should return name" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src, -> { /_/})
    log_file.name.should eq "access_log.gz"
  end 

  it "should raise an error for invalid line format" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    expect_raises(ApacheLogParser::LogFile::InvalidFormatError) do
      log_file = ApacheLogParser::LogFile.new(src, -> { /NOENT/ })
      log_file.each_row {}
    end
  end

  it "should collect data for each line" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src, -> { /^(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)/ })
    rows = [] of ApacheLogParser::Row
    log_file.each_row do |row|
      rows << row
    end
    rows.size.should eq 30
    rows.each do |row|
      row.true_client_ip.should_not be_nil
    end
  end
end
