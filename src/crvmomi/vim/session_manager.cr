module CrVmomi
  class VIM::SessionManager < VIM::ManagedObject
    def login(userName, password, locale = nil)
      desc = DescType.from({
        "params" => [
          ParamType.from({
            "name" => "userName",
            "is-array" => false,
            "is-optional" => false,
            "version-id-ref" => nil,
            "wsdl_type" => "xsd:string"
          }),
          ParamType.from({
            "name" => "password",
            "is-array" => false,
            "is-optional" => false,
            "version-id-ref" => nil,
            "wsdl_type" => "xsd:string"
          }),
          ParamType.from({
            "name" => "locale",
            "is-array" => false,
            "is-optional" => true,
            "version-id-ref" => nil,
            "wsdl_type" => "xsd:string"
          })
        ],
        "result" => ResultType.from({
          "is-array" => false,
          "is-optional" => false,
          "is-task" => false,
          "version-id-ref" => nil,
          "wsdl_type" => "UserSession"
        })
      })

      params = {
        userName: userName,
        password: password
      }
      params["locale"] = locale unless locale.nil?

      connection.call("Login", desc, self, params)
    end

    def logout
      desc = DescType.from({
        "params" => [] of ParamType,
        "result" => ResultType.from({
          "is-array" => false,
          "is-optional" => false,
          "is-task" => false,
          "version-id-ref" => nil,
          "wsdl_type" => nil
        })
      })

      params = {} of String => String

      connection.call("Logout", desc, self, params)
    end
  end
end
