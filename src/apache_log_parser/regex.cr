require "./filters.cr"

module ApacheLogParser
  struct Regex
    TIME = %q{\[(?<time>\d{2}\/\w{3}\/\d{4}:\d{2}:\d{2}:\d{2} [\+|-]\d{4})\]}
    REQUEST = %q{ "(?<request>.*?)"}
    STATUS = %q{.*? (?<status>\d{3})}
    USER_AGENT = %q{ .+"(?<user_agent>[Mozilla|Opera|ELinks|Links|Lynx]?.+)"}
    TRUE_IP = %q{ .*?"(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3})"}
    ORDERED = [TIME, REQUEST, STATUS, USER_AGENT, TRUE_IP]
    FILTERS_REGEX_PAIRS = [
      {["Request"], REQUEST},
      {["Status"], STATUS},
      {["UserAgent"], USER_AGENT}
    ]

    def initialize(@filters = [] of String); end

    def call(regex = ENV["REGEX"]?)
      return /#{regex}/ if regex
      /#{normalize.uniq.join}/
    end

    private def normalize
      ORDERED.clone.tap do |group|
        FILTERS_REGEX_PAIRS.each do |filters, regex|
          group.delete(regex) unless any_used_filter?(filters)
        end
      end
    end

    private def any_used_filter?(filters)
      filters.any? do |filter|
        @filters.includes?(filter)
      end
    end
  end
end
