module Stubs
  extend self

  DEFAULT_PATH = File.expand_path("../../samples", __FILE__)

  class Row
    getter :time, :status, :verb, :true_client_ip

    def initialize(@time : Time, @status : String, @verb : String, @true_client_ip : String)
    end
  end

  def rows
    19.times.reduce([] of Row) do |rows, i|
      rows << Row.new(Time.new(2016, 2, 2, 11, 23 + i, 1), 
                      i.even? ? "201" : "301",
                      i.even? ? "get" : "post",
                      i.even? ? "211.157.178.224" : "-")
      rows
    end
  end
end
