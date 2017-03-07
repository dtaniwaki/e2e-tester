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
end
