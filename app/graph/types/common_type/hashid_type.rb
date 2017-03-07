module CommonType
  module HashidType
    def self.define(hashids:, &block)
      GraphQL::ScalarType.define do
        instance_exec(&block)
        coerce_input ->(s) { hashids.decode(s)[0] }
        coerce_result ->(s) { hashids.encode(s)[0] }
      end
    end
  end
end
