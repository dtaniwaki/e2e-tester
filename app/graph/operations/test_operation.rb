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
end
