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
    field :testVersions, !types[TestVersionType::Entity] do
      argument :limit, types.Int
      resolve ->(obj, args, ctx) {
        TestVersion.lazy_find(ctx, obj.test_version_ids.slice(0, args[:limit]))
      }
    end
  end
end
