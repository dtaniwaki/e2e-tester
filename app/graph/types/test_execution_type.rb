module TestExecutionType
  Entity = GraphQL::ObjectType.define do
    name 'TestExecutionEntity'
    description 'A test execution'

    interfaces [CommonType::EntityInterface, CommonType::CrudInterface]

    field :state, !StateEnum
    field :exectedAt, !CommonType::DateTimeType, property: :executed_at
    field :testVersionId, !types.ID, property: :test_version_id
    field :testVersion, -> { !TestVersionType::Entity } do
      resolve ->(obj, _args, ctx) { TestVersion.lazy_find(ctx, obj.test_version_id) }
    end
    field :executedBy, -> { !UserType::Entity } do
      resolve ->(obj, _args, ctx) { User.lazy_find(ctx, obj.user_id) }
    end
  end

  Connection = CommonType::ConnectionType.define entity_type: Entity do
    name "TestExecutionConnection"
    description "Test executions"
  end

  StateEnum = GraphQL::EnumType.define do
    name 'TestExecutionStateEnum'
    value 'running'
    value 'done'
    value 'failed'
  end
end
