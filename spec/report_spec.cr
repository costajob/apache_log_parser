require "./spec_helper.cr"

describe ApacheLogParser::Report do
  it "should render the header" do
    report = ApacheLogParser::Report.new("access.gz")
    io = IO::Memory.new
    report.render(Stubs.rows, io)
    io.rewind
    iter = io.each_line
    iter.next
    iter.next.should eq "access.gz         19     "
    iter.next.should eq "\e[0m-------------------------"
    iter.next
    iter.next.should eq "HTTP STATUS       HITS   "
    iter.next.should eq "\e[0m-------------------------"
    iter.next.should eq "201               10"
    iter.next.should eq "301               9"
    iter.next
    iter.next.should eq "HOUR              HITS   "
    iter.next.should eq "\e[0m-------------------------"
    iter.next.should eq "2016-02-02 11h    19"
    iter.next
    iter.next.should eq "TRUE IP           HITS   "
    iter.next.should eq "\e[0m-------------------------"
    iter.next.should eq "211.157.178.224   10"
    iter.next.should be_a Iterator::Stop
  end
end
