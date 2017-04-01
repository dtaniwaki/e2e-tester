module BrowserOperation
  HashidType = CommonType::HashidType.define hashids: Browser::Base.hashids do
    name 'BrowserHashidType'
  end

  ShowQuery = GraphQL::Field.define do
    type BrowserType::Entity
    argument :id, !HashidType
    description 'Find a Browser by ID'
    resolve ->(_obj, args, ctx) { Browser::Base.lazy_find(ctx, args['id']) }
  end

  IndexQuery = GraphQL::Field.define do
    type BrowserType::Connection

    argument :ids, types[HashidType]
    argument :page, types.Int
    argument :limit, types.Int
    resolve IndexOperationResolver.new(->(_obj, args, ctx) {
      Browser::Base
    })
  end
end
