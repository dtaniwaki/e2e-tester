module Api
  module Graphql
    class QueriesController < Api::BaseController
      include LocaleConcern

      before_action :set_locale

      def show
        execute
      end

      def create
        execute
      end

      private

      def execute
        result = Schema.execute(
          query_string,
          variables: query_variables,
          context: {
            current_user: current_user
          }
        )
        render body: result.to_json
      end

      def query_string
        params.require(:query)
      end

      def query_variables
        variables = params[:variables]&.permit!
        if variables.blank?
          {}
        elsif variables.is_a?(String)
          JSON.parse(variables)
        else
          variables
        end
      end

      def current_user
        request.headers['Authorization'] =~ /\ABearer\s+(.*)\Z/
        token = Regexp.last_match(1)
        token ||= query_variables[:token]
        return if token.nil?
        token = UserApiToken.eager_load(:user).find_by(token: token)
        token&.user
      end
    end
  end
end
