module CrVmomi
  module BasicTypes
    class Base
      def self.wsdl_name
        name.split("::").last
      end
    end

    class ObjectWithProperties < Base
    end

    class ObjectWithMethods < Base
    end

    class DataObject < ObjectWithProperties
    end

    class ManagedObject < ObjectWithMethods
      getter connection : VIM
      getter _ref : String

      def initialize(@connection, @_ref)
      end
    end

    class Enum < Base
    end

    class MethodFault < DataObject
    end

    class LocalizedMethodFault < DataObject
    end

    class RuntimeFault < MethodFault
    end

    class ManagedObjectReference
      def self.wsdl_name
        name.split("::").last
      end
    end

    class Boolean
      def self.wsdl_name
        "xsd:boolean"
      end
    end

    class AnyType
      def self.wsdl_name
        "xsd:anyType"
      end
    end

    class Binary
      def self.wsdl_name
        "xsd:binary"
      end
    end

    class KeyValue
      def self.wsdl_name
        name.split("::").last
      end

      getter key : String
      getter value : String

      def initialize(@key, @value)
      end
    end
  end
end
