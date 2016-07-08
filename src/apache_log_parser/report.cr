require "colorize"
require "./row.cr"

module ApacheLogParser
  class Report
    HOUR_FORMAT = "%F %Hh"

    def initialize(@name : String,
                   @hits_by_status = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_hour = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_ip = Hash(String, Int32).new { |h,k| h[k] = 0 })
    end

    def render(rows, io : IO)
      collect_hits(rows)
      io.puts
      io.puts title(rows.size)
      io.puts data(title: "HTTP STATUS", data: @hits_by_status, sort: true)
      io.puts data(title: "HOUR", data: @hits_by_hour)
      io.puts data(title: "TRUE IP", data: @hits_by_ip, limit: 10, sort: true)
    end

    private def collect_hits(rows)
      rows.each do |row|
        @hits_by_status[row.status.to_s] += 1
        @hits_by_hour[row.time.to_s(HOUR_FORMAT)] += 1
        @hits_by_ip[row.true_client_ip] += 1
      end
    end

    private def title(n)
      String.build do |str|
        str << @name.colorize(:yellow).bold
        str << " - "
        str << "#{n}".colorize(:magenta).bold
      end
    end

    private def header(title)
      String.build do |str|
        str << ("\n%-17s %-7s\n" % [title, "HITS"]).colorize(:light_gray).bold
        str << "-" * 22
        str << "\n"
      end
    end

    private def data(title, data, limit = 100, sort = false)
      String.build do |str|
        str << header(title)
        data = data.to_a
        data.sort! { |x, y| y[1] <=> x[1] } if sort
        data.each_with_index do |matrix, i|
          break if i == limit
          str << "%-17s %d\n" % [matrix[0], matrix[1]]
        end
      end
    end
  end
end
