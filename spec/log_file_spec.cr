require "./spec_helper"

describe ApacheLogParser::LogFile do
  it "should return name" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src)
    log_file.name.should eq "access_log.gz"
  end 

  it "should yeald each line" do
    src = File.expand_path("../../samples/access_log.gz", __FILE__)
    log_file = ApacheLogParser::LogFile.new(src)
    lines = [] of String
    log_file.each_line do |line|
      lines << line
    end
    lines.size.should eq 23
    lines[0].should eq %(23.63.227.241 - - [03/Jul/2016:03:56:21 +0100] "GET / HTTP/1.1" 302 94 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko" "192.40.202.240"\n)
  end
end
