require "colorize"
require "./row.cr"

module ApacheLogParser
  class Report
    def initialize(@name : String,
                   @hits_by_status = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_hour = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_ip = Hash(String, Int32).new { |h,k| h[k] = 0 })
    end

    def render(rows, io : IO)
      collect_hits(rows)
      io.puts title
      io.puts data("HTTP STATUS", @hits_by_status)
      io.puts data("HOUR", @hits_by_hour)
      io.puts data("TRUE IP", @hits_by_ip)
    end

    private def collect_hits(rows)
      rows.each do |row|
        @hits_by_status[row.status.to_s] += 1
        @hits_by_hour[row.time.to_s("%F %Hh")] += 1
        @hits_by_ip[row.true_client_ip] += 1
      end
    end

    private def title
      @name.colorize(:yellow).bold
    end

    private def header(title)
      String.build do |str|
        str << ("\n%-17s %-7s\n" % [title, "HITS"]).colorize(:light_gray).bold
        str << "-" * 22
        str << "\n"
      end
    end

    private def data(title, data)
      String.build do |str|
        str << header(title)
        data.each do |key, count|
          str << "%-17s %d\n" % [key, count]
        end
      end
    end
  end
end
