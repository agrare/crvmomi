require "./vmodl"

module CrVmomi
  class VIM < Vmodl
    def self.connect(host, port = nil, ssl = true, insecure = false)
      new(host, port, ssl, insecure)
    end
  end
end
