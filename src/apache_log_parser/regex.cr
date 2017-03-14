require "./filters.cr"

module ApacheLogParser
  struct Regex
    TIME = %q{\[(?<time>\d{2}\/\w{3}\/\d{4}:\d{2}:\d{2}:\d{2} [\+|-]\d{4})\]}
    REQUEST = %q{ "(?<request>.+)"}
    STATUS = %q{.*? (?<status>\d{3})}
    USER_AGENT = %q{ .+"(?<user_agent>[Mozilla|Opera|ELinks|Links|Lynx]?.+)"}
    TRUE_IP = %q{ .*?"(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)"}
    DEFAULT_REGEXS = [TIME, STATUS, TRUE_IP]
    REGEX_BY_FILTER = {
      "Request" => {TIME, REQUEST},
      "Verb" => {TIME, REQUEST},
      "UserAgent" => {STATUS, USER_AGENT}
    }

    def initialize(@filters = [] of String); end

    def call(regex = ENV["REGEX"]?)
      return /#{regex}/ if regex
      /#{group.uniq.join}/
    end

    private def group
      DEFAULT_REGEXS.clone.tap do |regexs|
        REGEX_BY_FILTER.each do |filter, data|
          prev, succ = data
          index = next_index(regexs, prev)
          regexs.insert(index, succ) if @filters.includes?(filter)
        end
      end
    end

    private def next_index(regexs, prev)
      regexs.index(prev).as(Int32) + 1
    end
  end
end
