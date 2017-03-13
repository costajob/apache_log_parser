module ApacheLogParser
  struct Row
    TIME_FORMAT = "%d/%b/%Y:%H:%M:%S %z"
    EPOCH = Time.epoch(0)
    EMPTY = ""

    getter :time, :request, :status, :user_agent, :true_client_ip

    def initialize(data)
      @time = data["time"]? ? Time.parse(data["time"], TIME_FORMAT) : EPOCH
      @request = data["request"]? || EMPTY
      @status = data["status"]? || EMPTY
      @user_agent = data["user_agent"]? || EMPTY
      @true_client_ip = data["true_client_ip"]? || EMPTY
    end
  end
end
