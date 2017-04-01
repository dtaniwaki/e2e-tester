module TestExecutionOperation
  HashidType = CommonType::HashidType.define hashids: TestExecution.hashids do
    name 'TestExecutionHashidType'
  end

  ShowQuery = GraphQL::Field.define do
    type TestExecutionType::Entity
    argument :id, !HashidType
    description 'Find a TestExecution by ID'
    resolve ->(_obj, args, ctx) { TestExecution.lazy_find(ctx, args['id']) }
  end

  IndexQuery = GraphQL::Field.define do
    type TestExecutionType::Connection

    argument :ids, types[HashidType]
    argument :page, types.Int
    argument :limit, types.Int
    resolve IndexOperationResolver.new(->(_obj, _args, ctx) {
      ctx[:current_user].test_executions
    })
  end
end
