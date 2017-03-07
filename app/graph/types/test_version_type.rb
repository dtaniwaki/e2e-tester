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
  end
end
