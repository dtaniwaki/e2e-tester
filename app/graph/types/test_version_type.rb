module TestVersionType
  Entity = GraphQL::ObjectType.define do
    name 'TestVersionEntity'
    description 'A test version'

    interfaces [CommonType::EntityInterface, CommonType::CrudInterface, TestStepSetType::Interface]

    field :test, -> { !TestType::Entity } do
      resolve ->(obj, _args, ctx) { Test.lazy_find(ctx, obj.test_id) }
    end
    field :createdBy, -> { !UserType::Entity } do
      resolve ->(obj, _args, ctx) { User.lazy_find(ctx, obj.user_id) }
    end
    field :testExecutions, AssociationField.define(
      TestExecutionType::Connection,
      ->(obj, _args, _ctx) { obj.test_executions })
  end

  Connection = CommonType::ConnectionType.define entity_type: Entity do
    name "TestVersionConnection"
    description "Test versions"
  end
end
