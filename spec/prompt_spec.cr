require "./spec_helper.cr"

describe ApacheLogParser::Prompt do
  it "should write to specified output" do
    output = IO::Memory.new
    input = IO::Memory.new("n")
    Stubs::Prompt.ask("is it true", output, input) {}
    output.to_s.should eq "\e[36;1m\nis it true (Y/N)?\e[0m\n"
  end

  it "should prevent execution for negative answer" do
    output = IO::Memory.new
    input = IO::Memory.new("n")
    executed = false
    Stubs::Prompt.ask("is it true", output, input) do
      executed = true
    end
    executed.should be_false
  end

  it "should do execution for positive answer" do
    output = IO::Memory.new
    input = IO::Memory.new("y")
    executed = false
    Stubs::Prompt.ask("is it true", output, input) do
      executed = true
    end
    executed.should be_true
  end
end
