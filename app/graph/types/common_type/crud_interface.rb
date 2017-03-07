module CommonType
  CrudInterface = GraphQL::InterfaceType.define do
    name 'CrudInterface'
    field :createdAt, !DateTimeType, property: :created_at
    field :updatedAt, !DateTimeType, property: :updated_at
  end
end
