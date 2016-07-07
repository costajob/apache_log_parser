module ApacheLogParser
  struct Row
    TIME_FORMAT = "%d/%b/%Y:%H:%M:%S %z"

    getter :host, :logname, :user, :server_name, :time, :request, :status, :bytes, :referer, :user_agent, :true_client_ip

    def initialize(@host : String, @logname : String, @user : String, @server_name : String,
                   @time : Time, @request : String, @status : Int32, @bytes : Int32,
                   @referer : String, @user_agent : String, @true_client_ip : String)
    end

    def self.factory(data)
      new(host: data["host"]? || "",
          logname: data["logname"]? || "",
          user: data["user"]? || "",
          server_name: data["server_name"]? || "",
          time: set_time(data["time"]?),
          request: data["request"]? || "",
          status: set_status(data["status"]?),
          bytes: set_bytes(data["bytes"]?),
          referer: data["referer"]? || "",
          user_agent: data["user_agent"]? || "",
          true_client_ip: data["true_client_ip"]? || "")
    end

    private def self.set_time(time)
      return Time.epoch(0) unless time
      Time.parse(time.as(String), TIME_FORMAT)
    end

    private def self.set_status(status)
      return 0 unless status
      status.as(String).to_i
    end

    private def self.set_bytes(bytes)
      return 0 if !bytes || bytes == "-"
      bytes.as(String).to_i
    end
  end
end
