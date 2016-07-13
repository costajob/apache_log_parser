require "colorize"
require "./row.cr"

module ApacheLogParser
  class Report
    HOUR_FORMAT = "%F %Hh"
    HR = "-" * 25

    def initialize(@name : String,
                   @hits_by_status = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_hour = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_ip = Hash(String, Int32).new { |h,k| h[k] = 0 })
    end

    def render(rows, io : IO)
      collect_hits(rows)
      io.puts title(rows.size)
      io.puts hits(title: "HTTP STATUS", data: @hits_by_status, sort: true)
      io.puts hits(title: "HOUR", data: @hits_by_hour)
      io.puts hits(title: "TRUE IP", data: @hits_by_ip, limit: 10, sort: true)
    end

    private def collect_hits(rows)
      rows.each do |row|
        @hits_by_status[row.status] += 1
        @hits_by_hour[row.time.to_s(HOUR_FORMAT)] += 1
        @hits_by_ip[row.true_client_ip] += 1
      end
    end

    private def title(n)
      String.build do |str|
        str << ("\n%-17s %-7\d\n" % [@name, n]).colorize(:yellow).bold
        str << HR
        str << "\n"
      end
    end

    private def header(title)
      String.build do |str|
        str << ("\n%-17s %-7s\n" % [title, "HITS"]).colorize(:light_gray).bold
        str << HR
        str << "\n"
      end
    end

    private def hits(title, data, limit = 100, sort = false)
      String.build do |str|
        str << header(title)
        normalize_data(data, sort).each_with_index do |row, i|
          break if i == limit
          str << "%-17s %d\n" % [row[0], row[1]]
        end
      end
    end

    private def normalize_data(data, sort)
      data.delete("-")
      data = data.to_a
      data.sort! { |x, y| y[1] <=> x[1] } if sort
      data
    end
  end
end
