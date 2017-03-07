module Api
  module Graphql
    class SchemasController < Api::BaseController
      def show
        render body: GraphQL::Schema::Printer.print_schema(Schema)
      end
    end
  end
end
