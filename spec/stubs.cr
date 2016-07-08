module Stubs
  extend self

  DEFAULT_PATH = File.expand_path("../../samples", __FILE__)

  class Row
    getter :time, :status, :user_agent, :true_client_ip

    def initialize(@time : Time, @status : Int32, 
                   @user_agent : String, @true_client_ip : String)
    end
  end

  def rows
    19.times.reduce([] of Row) do |rows, i|
      rows << Row.new(Time.new(2016, 2, 2, 11, 23 + i, 1), 
                      i.even? ? 201 : 301,
                      "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13F69 Safari/601.1", 
                      i.even? ? "211.157.178.224" : "182.249.245.24")
      rows
    end
  end

  def formats
    [%(%t %_ %>s %_ "%{True-Client-IP}i"$),
     %(%h %l %u %t \"%r\" %>s %b),
     %(%v %h %l %u %t \"%r\" %>s %b),
     %(%h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-Agent}i" "%{True-Client-IP}i")]
  end

  def regexs
    [/\[(?<time>.+)\] .+? (?<status>\b\d{3}\b) .+? "(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)"$/,
     /(?<host>(?:[0-9]{1,3}\.){3}[0-9]{1,3}) (?<logname>\w+|-) (?<user>\w+|-) \[(?<time>.+)\] "(?<request>.+?|.?)" (?<status>\b\d{3}\b) (?<bytes>\w+|-)/,
     /(?<server_name>\w+) (?<host>(?:[0-9]{1,3}\.){3}[0-9]{1,3}) (?<logname>\w+|-) (?<user>\w+|-) \[(?<time>.+)\] "(?<request>.+?|.?)" (?<status>\b\d{3}\b) (?<bytes>\w+|-)/,
     /(?<host>(?:[0-9]{1,3}\.){3}[0-9]{1,3}) (?<logname>\w+|-) (?<user>\w+|-) \[(?<time>.+)\] "(?<request>.+?|.?)" (?<status>\b\d{3}\b) (?<bytes>\w+|-) "(?<referer>.+?|.?)" "(?<user_agent>.+?|.?)" "(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)"/]
  end
end
