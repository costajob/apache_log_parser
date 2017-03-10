module Stubs
  extend self

  DEFAULT_PATH = File.expand_path("../../samples", __FILE__)

  class Row
    getter :time, :request, :status, :user_agent, :true_client_ip

    def initialize(@time : Time, @request : String, @status : String, @user_agent : String, @true_client_ip : String)
    end
  end

  def rows
    19.times.reduce([] of Row) do |rows, i|
      rows << Row.new(Time.new(2016, 2, 2, 11, 23 + i, 1, 0, Time::Kind::Utc), 
                      i.even? ? "GET / HTTP/1.1" : "HEAD /healthcheck.html HTTP/1.0",
                      i.even? ? "201" : "301",
                      i.even? ? "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13F69 Safari/601.1" : "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36",
                      i.even? ? "211.157.178.224" : "-")
      rows
    end
  end
end
