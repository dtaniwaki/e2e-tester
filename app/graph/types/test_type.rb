module TestType
  Entity = GraphQL::ObjectType.define do
    name 'TestEntity'
    description 'A test execution'

    interfaces [CommonType::EntityInterface, CommonType::CrudInterface]

    field :createdBy, -> { !UserType::Entity } do
      resolve ->(obj, _args, ctx) { User.lazy_find(ctx, obj.user_id) }
    end
    field :currentTestVersionId, !types.ID, property: :current_test_version_id
    field :currentTestVersion, -> { !TestVersionType::Entity } do
      resolve ->(obj, _args, ctx) { TestVersion.lazy_find(ctx, obj.current_test_version_id) }
    end
    field :testVersions, AssociationField.define(
      TestVersionType::Connection,
      ->(obj, _args, _ctx) { obj.test_versions })
  end

  Connection = CommonType::ConnectionType.define entity_type: Entity do
    name "TestConnection"
    description "Tests"
  end
end
