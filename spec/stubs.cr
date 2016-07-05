module Stubs
  extend self

  def formats
    [%(%h %l %u %t \"%r\" %>s %b),
     %(%v %h %l %u %t \"%r\" %>s %b),
     %(%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\")]
  end

  def regexs
    [/(?<host>(?:d{1,3}.){3}d{1,3}) (?<logname>w+|-) (?<user>w+|-) [(?<time>.+)] "(?<request>.+)" (?<status>d{3}) (?<bytes>w+|-)/,
     /(?<server_name>w+) (?<host>(?:d{1,3}.){3}d{1,3}) (?<logname>w+|-) (?<user>w+|-) [(?<time>.+)] "(?<request>.+)" (?<status>d{3}) (?<bytes>w+|-)/,
     /(?<host>(?:d{1,3}.){3}d{1,3}) (?<logname>w+|-) (?<user>w+|-) [(?<time>.+)] "(?<request>.+)" (?<status>d{3}) (?<bytes>w+|-) "(?<referer>.+)" "%{User-agent}i"/]
  end
end
