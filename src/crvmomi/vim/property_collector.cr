module CrVmomi
  class VIM::PropertyCollector < VIM::ManagedObject
    def cancel_retrieve_properties_ex(token : String)
    end

    def cancel_wait_for_updates()
    end

    def check_for_updates(version : String = nil)
    end

    def continue_retrieve_properties_ex(token : String)
    end

    def create_filter(spec : VIM::PropertyFilterSpec, partialUpdates : Bool)
      desc = DescType.from({
        "params" => [
          ParamType.from({
            "name" => "spec",
            "is-array" => false,
            "is-optional" => false,
            "version-id-ref" => nil,
            "wsdl_type" => "PropertyFilterSpec"
          }),
          ParamType.from({
            "name" => "partialUpdates",
            "is-array" => false,
            "is-optional" => false,
            "version-id-ref" => nil,
            "wsdl_type" => "xsd:boolean"
          })
        ],
        "result" => ResultType.from({
          "is-array" => false,
          "is-optional" => false,
          "is-task" => false,
          "version-id-ref" => nil,
          "wsdl_type" => "PropertyFilter"
        })
      })

      params = {
        "spec" => spec,
        "partialUpdates" => partialUpdates
      }

      connection.call("CreateFilter", desc, self, params)
    end

    def create_property_collector()
    end

    def destroy_property_collector()
    end

    def retrieve_properties(specSet : Array(VIM::PropertyFilterSpec))
    end

    def retrieve_properties_ex(specSet : Array(VIM::PropertyFilterSpec), options : VIM::RetrieveOptions)
    end

    def wait_for_updates(version : String = nil)
    end

    def wait_for_updates_ex(version : String = nil, options : VIM::WaitOptions = nil)
    end
  end
end
