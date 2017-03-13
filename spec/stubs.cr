module Stubs
  extend self

  DEFAULT_PATH = File.expand_path("../../samples", __FILE__)

  def lines
    [%q{23.63.227.241 - - [03/Jul/2016:03:56:21 +0100] "GET / HTTP/1.1" 302 94 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko" "192.40.202.240"},
     %q{23.216.10.10 - - [03/Jul/2016:03:56:21 +0100] "GET /images/ecommerce/styles_new/201501/web_zoomout/400249_CEMMN_5609_008_web_zoomout_new_theme.jpg HTTP/1.1" 304 - "http://www-m.gucci.com/cn/styles/400249CEMMN5609" "Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 search%2F1.0 baiduboxapp/0_2.0.4.7_enohpi_4331_057/3.8_2C2%257enohPi/1099a/180FB6F93A26E364B9EAFB76C10B257D6B6D25AE2FCNGSRMMKL/1 dueriosapp 7.4.0 rv:7.4.0.2 (iPhone; iPhone OS 8.3; zh_CN)" "211.157.178.224"},
     %q{23.215.15.16 - - [08/Mar/2017:00:00:22 +0000] "GET /us/en/customer/ajax/basic-info?key=1488931221858 HTTP/1.1" 302 20 "https://www.gucci.com/us/en/ca/beauty/lips/lipstick-c-beauty-lips-lipstick" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393" TCIP: "192.40.127.248" "A4B1597381D139651EEA98F62F3B217A" 6435},
    %q{10.48.11.3 - - [03/Jul/2016:03:56:25 +0100] "HEAD /healthcheck.html HTTP/1.0" 200 - "-" "-" "-"}
    ]
  end

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
