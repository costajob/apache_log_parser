module Stubs
  extend self

  def formats
    [%(%h %l %u %t \"%r\" %>s %b),
     %(%v %h %l %u %t \"%r\" %>s %b),
     %(%h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-Agent}i" "%{True-Client-IP}i")]
  end

  def regexs
    [/(?<host>(?:[0-9]{1,3}\.){3}[0-9]{1,3}) (?<logname>\w+|-) (?<user>\w+|-) \[(?<time>.+)\] "(?<request>.+?)" (?<status>\d{3}) (?<bytes>\w+|-)/,
     /(?<server_name>\w+) (?<host>(?:[0-9]{1,3}\.){3}[0-9]{1,3}) (?<logname>\w+|-) (?<user>\w+|-) \[(?<time>.+)\] "(?<request>.+?)" (?<status>\d{3}) (?<bytes>\w+|-)/,
     /(?<host>(?:[0-9]{1,3}\.){3}[0-9]{1,3}) (?<logname>\w+|-) (?<user>\w+|-) \[(?<time>.+)\] "(?<request>.+?)" (?<status>\d{3}) (?<bytes>\w+|-) "(?<referer>.+?)" "(?<user_agent>.+?)" "(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3})"/]
  end
end
