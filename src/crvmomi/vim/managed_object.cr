module CrVmomi
  class VIM::ManagedObject
    getter connection : VIM
    getter _ref : String

    def initialize(@connection, @_ref)
    end

    def self.wsdl_name
      name.split("::").last
    end
  end
end
