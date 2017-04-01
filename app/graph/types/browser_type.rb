module BrowserType
  Entity = GraphQL::ObjectType.define do
    name 'BrowserEntity'
    description 'A browser'

    interfaces [CommonType::EntityInterface, CommonType::CrudInterface]

    field :type, !types.String
    field :device, !types.String
    field :os, !types.String
    field :os_version, !types.String
    field :browser, !types.String
    field :browser_version, !types.String
    field :name, !types.String
    field :disabled, !types.Boolean
    field :deprecated, !types.Boolean
  end

  Connection = CommonType::ConnectionType.define entity_type: Entity do
    name "BrowserConnection"
    description "Test executions"
  end
end
