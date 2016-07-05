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
    lines = [] of Regex::MatchData?
    log_file.each_line do |line|
      lines << line
    end
    lines.size.should eq 23
    lines[0].try(&.["true_client_ip"]).should eq "192.40.202.240"
  end
end
