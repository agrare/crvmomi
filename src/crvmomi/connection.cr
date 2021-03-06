require "http/client"

module CrVmomi
  class Connection
    property cookie : String?
    getter host : String
    getter path : String
    getter port : Int32
    getter ssl : Bool
    getter insecure : Bool
    getter debug : Bool
    getter read_timeout : Int32
    getter connect_timeout : Int32

    @http : HTTP::Client?

    def initialize(@host, port = nil, @ssl = true, @insecure = false, @debug = false, @read_timeout = 1_000_000, @connect_timeout = 60)
      @port = port || (@ssl ? 443 : 80)
      @http = nil
      @path = "/sdk"
      restart_http
    end

    def vc_session_cookie
      cookie.try &.split('"')[1]
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

    private def build_header(xml : XML::Builder)
      session_cookie = vc_session_cookie
      if session_cookie
        xml.element("vcSessionCookie") { xml.text session_cookie }
      end
    end

    private def build_header?
      !cookie.nil?
    end

    def soap_envelope(&block : XML::Builder -> _)
      header_proc = build_header? ? ->build_header(XML::Builder) : nil
      SimpleSoap.envelope(header_proc, &block)
    end

    def request(soap_action, soap_body)
      puts "Request:\n#{soap_body}\n" if debug

      soap_response, http_response =
        begin
          SimpleSoap.request(http, path, soap_action, soap_body, cookie)
        rescue ex
          restart_http
          raise ex
        end

      puts "Response:\n#{soap_response}\n" if debug

      @cookie = http_response.headers["set-cookie"] if http_response.headers.has_key?("set-cookie")
      soap_response
    end
  end
end
