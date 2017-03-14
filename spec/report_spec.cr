require "./spec_helper.cr"

describe ApacheLogParser::Report do
  it "should render the header" do
    report = ApacheLogParser::Report.new("access.gz")
    io = IO::Memory.new
    report.render(Stubs.rows, io)
    io.rewind
    iter = io.each_line
    iter.next
    iter.next.should eq "access.gz                      19        "
    iter.next
    iter.next
    iter.next.should eq "HTTP STATUS                    HITS      "
    iter.next.should eq "\e[0m----------------------------------------"
    iter.next.should eq "201                            10"
    iter.next.should eq "301                            9"
    iter.next
    iter.next.should eq "HOUR                           HITS      "
    iter.next.should eq "\e[0m----------------------------------------"
    iter.next.should eq "2016-02-02 11h                 19"
    iter.next
    iter.next.should eq "TRUE IP                        HITS      "
    iter.next.should eq "\e[0m----------------------------------------"
    iter.next.should eq "211.157.178.224                10"
    iter.next.should be_a Iterator::Stop
  end

  it "should print the limit header if specified" do
    report = ApacheLogParser::Report.new("access.gz")
    io = IO::Memory.new
    report.render(Stubs.rows, io, "3")
    io.rewind
    iter = io.each_line
    13.times { iter.next }
    iter.next.should eq "TRUE IP (top 3)                HITS      "
  end

  it "should highlight the hits greater than the specified limit" do
    report = ApacheLogParser::Report.new("access.gz", "10")
    io = IO::Memory.new
    report.render(Stubs.rows, io)
    io.rewind
    iter = io.each_line
    6.times { iter.next }
    iter.next.should eq "201                            \e[31;1m10\e[0m"
    iter.next.should eq "301                            9"
    3.times { iter.next }
    iter.next.should eq "2016-02-02 11h                 \e[31;1m19\e[0m"
    3.times { iter.next }
    iter.next.should eq "211.157.178.224                \e[31;1m10\e[0m"
  end
end
