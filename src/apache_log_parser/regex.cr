require "./filters.cr"

module ApacheLogParser
  struct Regex
    TIME = %q{\[(?<time>\d{2}\/\w{3}\/\d{4}:\d{2}:\d{2}:\d{2} [\+|-]\d{4})\]}
    REQUEST = %q{ "(?<request>.+)"}
    STATUS = %q{.*? (?<status>\d{3})}
    USER_AGENT = %q{ .+"(?<user_agent>[Mozilla|Opera|ELinks|Links|Lynx]?.+)"}
    TRUE_IP = %q{ .*?"(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)"}
    FILTER_ORDER = {
      "Request" => {TIME, REQUEST},
      "Verb" => {TIME, REQUEST},
      "UserAgent" => {STATUS, USER_AGENT},
    }

    def initialize(@filters = [] of String); end

    def call(regex = ENV["REGEX"]?)
      return /#{regex}/ if regex
      /#{group.uniq.join}/
    end

    private def group
      [TIME, STATUS, TRUE_IP].clone.tap do |group|
        FILTER_ORDER.each do |name, data|
          index = group.index(data[0]).as(Int32) + 1
          group.insert(index, data[1]) if @filters.includes?(name)
        end
      end
    end
  end
end
