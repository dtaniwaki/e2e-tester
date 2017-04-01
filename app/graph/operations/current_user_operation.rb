module CurrentUserOperation
  ShowQuery = GraphQL::Field.define do
    type CurrentUserType::Entity
    description 'Show current user'
    resolve ->(_obj, args, ctx) { ctx[:current_user] }
  end
end
