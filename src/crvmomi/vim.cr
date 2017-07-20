require "./vmodl"

module CrVmomi
  class VIM < Vmodl
    def self.connect(host, port = nil, ssl = true, insecure = false)
      new(host, port, ssl, insecure).tap do |vim|
        vim.serviceInstance.retrieve_service_content
      end
    end

    def serviceInstance
      VIM::ServiceInstance.new(self, "ServiceInstance")
    end
  end
end
