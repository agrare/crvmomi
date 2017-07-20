module CrVmomi
  class VIM::ServiceInstance < VIM::ManagedObject
    def retrieve_service_content
      desc = {
        "params": [] of ParamType,
        "result": {
          "is-array"=>false,
          "is-optional"=>false,
          "is-task"=>false,
          "version-id-ref"=>nil,
          "wsdl_type"=>"ServiceContent"
				}
      }

      params = {} of String => String

      connection.call("RetrieveServiceContent", desc, self, params)
    end
  end
end
