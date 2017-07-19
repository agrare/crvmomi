require "./vmodl"

module CrVmomi
  class VIM < Vmodl
    def self.connect(host, port = nil, path = "/sdk", ssl = true, insecure = false)
      port = ssl ? 443 : 80 if port.nil?

      new(host, port, path, ssl, insecure)
    end
  end
end
