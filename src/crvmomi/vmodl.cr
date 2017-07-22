require "simple_soap"

module CrVmomi
  class Vmodl < Connection
    alias ParamType  = NamedTuple("name": String, "is-array": Bool, "is-optional": Bool, "version-id-ref": String?, "wsdl_type": String)
    alias ResultType = NamedTuple("is-task": Bool, "is-array": Bool, "is-optional": Bool, "version-id-ref": String?, "wsdl_type": String?)
    alias DescType   = NamedTuple("params": Array(ParamType), "result": ResultType)

    getter namespace
    property version

    def initialize(host, port = nil, ssl = true, insecure = false, debug = false, @version = "6.5")
      @namespace = "urn:vim25"

      super(host, port, ssl: ssl, insecure: insecure, debug: debug)
    end

    def call(method, desc : DescType, this, params)
      soap_action = "" # Unused by VIM endpoint
      soap_body   = soap_envelope do |xml|
        xml.element(method, {"xmlns" => namespace}) do
          xml.element("_this", {"type" => this.class.wsdl_name}) { xml.text this._ref }
					object_to_xml(xml, "_this", "ManagedObject", false, this)
          desc["params"].each do |param|
            name = param["name"]
            type = param["wsdl_type"]

            if params.has_key?(name)
              val = params[name]
            elsif !param["is-optional"]
              raise "missing required parameter #{name}"
            end

            object_to_xml(xml, param["name"], param["wsdl_type"], param["is-array"], val)
          end
        end
      end

      request(soap_action, soap_body)
    end

		def object_to_xml(xml, name, type, is_array, object)
		  case object
      when Array, BasicTypes::KeyValue
      when BasicTypes::ManagedObject
        xml.element(name, {"type" => type}) { xml.text object._ref }
      when BasicTypes::DataObject
        xml.element(name, {"type" => type}) do
        end
      when BasicTypes::Enum
      when Hash
      when Symbol, String
        xml.element(name, {"type" => "xsd:string"}) { xml.text object.to_s }
      end
    end
  end
end
