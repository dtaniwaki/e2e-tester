module AssociationField
  module_function

  def define(connection_type, resolver)
    GraphQL::Field.define do
      type connection_type

      argument :page, types.Int
      argument :limit, types.Int
      resolve IndexOperationResolver.new(resolver)
    end
  end
end
