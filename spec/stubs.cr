module Stubs
  extend self

  DEFAULT_PATH = File.expand_path("../../samples", __FILE__)

  class Row
    getter :time, :request, :status, :true_client_ip

    def initialize(@time : Time, @request : String, @status : String, @true_client_ip : String)
    end
  end

  def rows
    19.times.reduce([] of Row) do |rows, i|
      rows << Row.new(Time.new(2016, 2, 2, 11, 23 + i, 1, 0, Time::Kind::Utc), 
                      i.even? ? "GET / HTTP/1.1" : "HEAD /healthcheck.html HTTP/1.0",
                      i.even? ? "201" : "301",
                      i.even? ? "211.157.178.224" : "-")
      rows
    end
  end
end
