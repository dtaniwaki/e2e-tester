module CommonType
  EntityInterface = GraphQL::InterfaceType.define do
    name 'EntityInterface'
    field :id, !types.ID, property: :to_param
  end
end
