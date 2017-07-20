require "http/client"

module CrVmomi
  class Connection
    property cookie : String?
    getter host : String
    getter path : String
    getter port : Int32
    getter ssl : Bool
    getter insecure : Bool
    getter read_timeout : Int32
    getter connect_timeout : Int32

    @http : HTTP::Client?

    def initialize(@host, port = nil, @ssl = true, @insecure = false, @read_timeout = 1_000_000, @connect_timeout = 60)
      @port = port || (@ssl ? 443 : 80)
      @http = nil
      @path = "/sdk"
      restart_http
    end

    def http
      @http.not_nil!
    end

    def restart_http
      begin
        @http.try &.close
      rescue ex
        puts "WARNING: Ignoring exception: #{ex.message}"
        puts ex.backtrace.join("\n")
      end

      tls = if ssl
              if insecure
                OpenSSL::SSL::Context::Client.insecure
              else
                # TODO: set certificate and key
                OpenSSL::SSL::Context::Client.new
              end
            else
              false
            end

      new_http = HTTP::Client.new(host, port, tls)
      new_http.read_timeout = read_timeout
      new_http.connect_timeout = connect_timeout

      @http = new_http
    end

    delegate soap_envelope, to: SimpleSoap

    def request(soap_action, soap_body)
      begin
        soap_response, http_response = SimpleSoap.request(http, path, soap_action, soap_body, cookie)
        @cookie = http_response.headers["set-cookie"] if http_response.headers.has_key?("set-cookie")

        soap_response
      rescue ex
        restart_http
        raise ex
      end
    end
  end
end
