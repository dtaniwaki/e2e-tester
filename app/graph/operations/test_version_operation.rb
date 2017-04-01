module TestVersionOperation
  HashidType = CommonType::HashidType.define hashids: TestVersion.hashids do
    name 'TestVersionHashidType'
  end

  ShowQuery = GraphQL::Field.define do
    type TestVersionType::Entity
    argument :id, !HashidType
    description 'Find a TestVersion by ID'
    resolve ->(_obj, args, ctx) { TestVersion.lazy_find(ctx, args['id']) }
  end

  IndexQuery = GraphQL::Field.define do
    type TestVersionType::Connection

    argument :ids, types[HashidType]
    argument :page, types.Int
    argument :limit, types.Int
    resolve IndexOperationResolver.new(->(_obj, _args, ctx) {
      ctx[:current_user].test_versions
    })
  end
end
