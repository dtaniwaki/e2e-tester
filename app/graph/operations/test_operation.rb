module TestOperation
  HashidType = CommonType::HashidType.define hashids: Test.hashids do
    name 'TestHashidType'
  end

  ShowQuery = GraphQL::Field.define do
    type TestType::Entity
    argument :id, !HashidType
    description 'Find a Test by ID'
    resolve ->(_obj, args, ctx) { Test.lazy_find(ctx, args['id']) }
  end

  IndexQuery = GraphQL::Field.define do
    type TestType::Connection

    argument :ids, types[HashidType]
    argument :page, types.Int
    argument :limit, types.Int
    resolve IndexOperationResolver.new(->(_obj, _args, ctx) {
      ctx[:current_user].tests
    })
  end
end
