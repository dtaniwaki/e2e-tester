module CurrentUserType
  Entity = GraphQL::ObjectType.define do
    name 'CurrentUserEntity'
    description 'A current user'

    interfaces [CommonType::CrudInterface]

    field :name, !types.String
    field :username, !types.String
    field :email, !types.String
  end
end
