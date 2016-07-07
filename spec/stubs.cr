module Stubs
  extend self

  module Row
    extend self

    def time
      Time.new(2016, 2, 2, 11, 24, 1)
    end

    def status
      201
    end

    def user_agent
      "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)"
    end
  end

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
