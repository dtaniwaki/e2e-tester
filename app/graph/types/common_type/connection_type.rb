module CommonType
  module ConnectionType
    module_function

    def define(entity_type:, &block)
      GraphQL::ObjectType.define do
        instance_exec &block

        field :pageInfo, !CommonType::PageInfoType, property: :itself
        field :nodes, !types[entity_type], property: :itself
      end
    end
  end
end
