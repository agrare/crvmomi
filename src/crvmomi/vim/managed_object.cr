module CrVmomi
  class VIM::ManagedObject
    getter connection : VIM
    getter _ref : String

    def initialize(@connection, @_ref)
    end

    def wsdl_name
      self.class.name.split("::").last
    end
  end
end
