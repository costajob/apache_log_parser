module ApacheLogParser
  struct Format
    FORMATS = {
      %(%_) => ".+?",
      %(%h) => "(?<host>(?:[0-9]{1,3}\\.){3}[0-9]{1,3})",
      %(%l) => "(?<logname>\\w+|-)",
      %(%u) => "(?<user>\\w+|-)",
      %(%v) => "(?<server_name>\\w+)",
      %(%t) => "\\[(?<time>.+)\\]",
      %("%r") => "\"(?<request>.+?|.?)\"",
      %(%>s) => "(?<status>\\b\\d{3}\\b)",
      %(%b) => "(?<bytes>\\w+|-)",
      %("%{Referer}i") => "\"(?<referer>.+?|.?)\"",
      %("%{User-Agent}i") => "\"(?<user_agent>.+?|.?)\"",
      %("%{True-Client-IP}i") => "\"(?<true_client_ip>(?:[0-9]{1,3}\\.){3}[0-9]{1,3}|-)\""
    }

    REPLACEMENTS = /#{FORMATS.keys.join("|")}/

    def initialize(@src : String)
    end

    def regex
      Regex.new(@src.gsub(REPLACEMENTS, FORMATS))
    end
  end
end
