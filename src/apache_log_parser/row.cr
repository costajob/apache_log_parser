module ApacheLogParser
  struct Row
    TIME_FORMAT = "%d/%b/%Y:%H:%M:%S %z"
    EPOCH = Time.epoch(0)
    DASH = "-"

    getter :host, :logname, :user, :server_name, :time, :request, :status, :bytes, :referer, :user_agent, :true_client_ip

    def initialize(data)
      @host = data["host"]? || DASH
      @logname = data["logname"]? || DASH
      @user = data["user"]? || DASH
      @server_name = data["server_name"]? || DASH
      @time = data["time"]? ? Time.parse(data["time"], TIME_FORMAT) : EPOCH
      @request = data["request"]? || DASH
      @status = data["status"]? || DASH
      @bytes = data["bytes"]? || DASH
      @referer = data["referer"]? || DASH
      @user_agent = data["user_agent"]? || DASH
      @true_client_ip = data["true_client_ip"]? || DASH
    end

    def []?(name)
      {% for ivar in @type.instance_vars %}
        return {{ivar.id}} if {{ivar.name.stringify}} == name
      {% end %}
    end
  end
end
