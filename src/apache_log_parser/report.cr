require "colorize"
require "./row.cr"

module ApacheLogParser
  class Report
    HOUR_FORMAT = "%F %Hh"
    DATA_WIDTH = 30
    HITS_WIDTH = 10
    HR = "-" * (DATA_WIDTH + HITS_WIDTH)
    LIMIT = ENV.fetch("LIMIT") { "-1" }
    HIGHLIGHT = ENV.fetch("HIGHLIGHT") { "200000" }

    @highlight : Int32

    def initialize(@name : String,
                   highlight = HIGHLIGHT,
                   @hits_by_status = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_hour = Hash(String, Int32).new { |h,k| h[k] = 0 },
                   @hits_by_ip = Hash(String, Int32).new { |h,k| h[k] = 0 })
      @highlight = highlight.to_i
    end

    def render(rows, io : IO, limit = LIMIT)
      return if rows.empty?
      collect_hits(rows)
      io.puts title(rows.size)
      io.puts hits(title: "HTTP STATUS", data: @hits_by_status, limit: -1, sort: true)
      io.puts hits(title: "HOUR", data: @hits_by_hour, limit: -1)
      io.puts hits(title: "TRUE IP", data: @hits_by_ip, limit: limit.to_i32, sort: true)
    end

    private def collect_hits(rows)
      rows.each do |row|
        @hits_by_status[row.status] += 1
        @hits_by_hour[row.time.to_s(HOUR_FORMAT)] += 1
        @hits_by_ip[row.true_client_ip] += 1
      end
    end

    private def title(n)
      ("\n%-#{DATA_WIDTH}s %-#{HITS_WIDTH}\d\n" % [@name, n]).colorize(:yellow).bold
    end

    private def header(title, limit)
      String.build do |str|
        str << ("\n%-#{DATA_WIDTH}s %-#{HITS_WIDTH}s\n" % ["#{title}#{limit_str(limit)}", "HITS"]).colorize(:light_gray).bold
        str << HR
        str << "\n"
      end
    end

    private def limit_str(limit)
      return "" if limit < 0
      " (top #{limit})"
    end

    private def hits(title, data, limit, sort = false)
      return if skip_header?(data)
      String.build do |str|
        str << header(title, limit)
        normalize_data(data, sort).each_with_index do |row, i|
          break if i == limit
          str << "%-#{DATA_WIDTH}s %s\n" % [row[0], highlight(row[1])]
        end
      end
    end

    private def normalize_data(data, sort)
      data.delete("-")
      data = data.to_a
      data.sort! { |x, y| y[1] <=> x[1] } if sort
      data
    end

    private def skip_header?(data)
      data.size == 1 && data.keys.includes?("-")
    end

    private def highlight(hits)
      return hits.to_s if hits < @highlight
      hits.to_s.colorize(:red).bold
    end
  end
end
