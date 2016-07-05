require "./spec_helper.cr"

describe ApacheLogParser::Format do
  it "should match formats with proper regex" do
    Stubs.formats.each_with_index do |src, i|
      format = ApacheLogParser::Format.new(src)
      format.regex.should eq Stubs.regexs[i]
    end
  end
end
