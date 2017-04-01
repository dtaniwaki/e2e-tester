Schema = GraphQL::Schema.define do
  max_depth 10

  instrument :field, FieldTimerInstrumentation.new
  instrument :query, AuthenticateInstrumentation
  instrument :query, QueryTimerInstrumentation

  resolve_type ->(obj, ctx) {
  }

  query GraphQL::ObjectType.define {
    name 'Query'
    description 'The query root for this schema'

    field :testExecution, TestExecutionOperation::ShowQuery
    field :testExecutions, TestExecutionOperation::IndexQuery
    field :test, TestOperation::ShowQuery
    field :tests, TestOperation::IndexQuery
    field :testVersion, TestVersionOperation::ShowQuery
    field :testVersions, TestVersionOperation::IndexQuery
    field :browser, BrowserOperation::ShowQuery
    field :browsers, BrowserOperation::IndexQuery
    field :currentUser, CurrentUserOperation::ShowQuery
  }
end
