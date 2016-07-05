module ApacheLogParser
  struct Format
    FORMATS = {
      %(%h) => "(?<host>(?:\d{1,3}\.){3}\d{1,3})",
      %(%l) => "(?<logname>\w+|-)",
      %(%u) => "(?<user>\w+|-)",
      %(%v) => "(?<server_name>\w+)",
      %(%t) => "\[(?<time>.+)\]",
      %("%r") => "\"(?<request>.+)\"",
      %(%>s) => "(?<status>\d{3})",
      %(%b) => "(?<bytes>\w+|-)",
      %("%{Referer}i") => "\"(?<referer>.+)\"",
      %("%{User-Agent}i") => "\"(?<user_agent>.+)\"",
      %("%{True-Client-IP}i") => "(?<true_client_ip>(?:\d{1,3}\.){3}\d{1,3})"
    }

    REPLACEMENTS = /#{FORMATS.keys.join("|")}/

    def initialize(@src : String)
    end

    def regex
      Regex.new(@src.gsub(REPLACEMENTS, FORMATS))
    end
  end
end
