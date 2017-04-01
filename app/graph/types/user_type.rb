module UserType
  Entity = GraphQL::ObjectType.define do
    name 'UserEntity'
    description 'A user'

    interfaces [CommonType::CrudInterface]

    field :name, !types.String
    field :username, !types.String
  end
end