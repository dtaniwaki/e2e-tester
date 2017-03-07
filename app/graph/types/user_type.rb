module UserType
  Entity = GraphQL::ObjectType.define do
    name 'UserEntity'
    description 'A user'

    interfaces [CommonType::EntityInterface, CommonType::CrudInterface]

    field :name, !types.String
    field :username, !types.String
    # field :email, !types.String
  end
end
