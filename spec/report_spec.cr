require "./spec_helper.cr"

describe ApacheLogParser::Report do
  it "should render the header" do
    report = ApacheLogParser::Report.new("access.gz")
    io = MemoryIO.new
    report.render(Stubs.rows, io)
    io.rewind
    iter = io.each_line
    iter.next
    iter.next.should eq "\e[33;1maccess.gz\e[0m\n"
    iter.next
    iter.next.should eq "HTTP STATUS       HITS   \n"
    iter.next.should eq "\e[0m----------------------\n"
    iter.next.should eq "201               10\n"
    iter.next.should eq "301               10\n"
    iter.next
    iter.next.should eq "HOUR              HITS   \n"
    iter.next.should eq "\e[0m----------------------\n"
    iter.next.should eq "2016-02-02 11h    20\n"
    iter.next
    iter.next.should eq "TRUE IP           HITS   \n"
    iter.next.should eq "\e[0m----------------------\n"
    iter.next.should eq "211.157.178.224   10\n"
    iter.next.should eq "182.249.245.24    10\n"
  end
end
