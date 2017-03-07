Schema = GraphQL::Schema.define do
  max_depth 5

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
    field :testVersion, TestVersionOperation::ShowQuery
  }
end
