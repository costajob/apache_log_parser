require "colorize"

module ApacheLogParser
  module Prompt
    VALID_ANSWERS = %w[Y y N n]

    def ask(msg, output = STDOUT, input = STDIN)
      res = ""
      until VALID_ANSWERS.includes?(res)
        output.puts "\n#{msg} (Y/N)?".colorize(:cyan).bold
        res = input.gets.as(String).chomp
      end
      yield if res.match(/y/i)
    end
  end
end
