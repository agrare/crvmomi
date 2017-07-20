require "simple_soap"

module CrVmomi
  class Vmodl < Connection
    alias ParamType  = NamedTuple("name": String, "is-array": Bool, "is-optional": Bool, "version-id-ref": String?, "wsdl_type": String)
    alias ResultType = NamedTuple("is-task": Bool, "is-array": Bool, "is-optional": Bool, "version-id-ref": String?, "wsdl_type": String?)
    alias DescType   = NamedTuple("params": Array(ParamType), "results": ResultType)

    getter namespace
    property version

    def initialize(host, port = nil, ssl = true, insecure = false, @version = "6.5")
      @namespace = "urn:vim25"

      super(host, port, ssl, insecure)
    end

    def call(method, desc, this, params)
      soap_action = "" # Unused by VIM endpoint
      soap_body   = soap_envelope do |xml|
        xml.element(method, {"xmlns" => namespace}) do
          xml.element("_this", {"type" => this.class.wsdl_name}) { xml.text this._ref }
          desc["params"].each do |param|
            name = param["name"]
            type = param["wsdl_type"]

            if params.has_key?(name)
              val = params[name]
            elsif !param["is-optional"]
              raise "Missing argument: #{name}"
            end

            xml.element(name, {"type" => type}) do
              xml.text val unless val.nil?
            end
          end
        end
      end

      request(soap_action, soap_body)
    end
  end
end
