module TestStepSetType
  Interface = GraphQL::InterfaceType.define do
    name 'TestStepSetInterface'

    field :number, !types.Int, property: :position
    field :createdBy, -> { !UserType::Entity } do
      resolve ->(obj, _args, ctx) { User.lazy_find(ctx, obj.user_id) }
    end
    field :baseTestStepSetId, types.ID, property: :base_test_step_set_id
    field :baseTestStepSet, -> { !TestStepSetType::Entity } do
      resolve ->(obj, _args, ctx) { TestStepSet.lazy_find(ctx, obj.base_test_step_set_id) }
    end
  end

  Entity = GraphQL::ObjectType.define do
    name 'TestStepSetEntity'
    description 'A test step set'

    interfaces [CommonType::EntityInterface, CommonType::CrudInterface, Interface]
  end
end
