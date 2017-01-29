module Api
  module V1
    class BaseController < Api::BaseController
      include Pundit
      include PunditExt
      include LocaleConcern
      include UrlHelper
      include I18nConcern
      helper :url

      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index
      before_action :authenticate_user!
      before_action :set_locale

      def set_pagination_header(records, params = request.params)
        links = []
        links << %(<#{url_for(params.merge(page: records.next_page))}>; rel="next") unless records.last_page?
        links << %(<#{url_for(params.merge(page: records.total_pages))}>; rel="last") unless records.last_page?
        links << %(<#{url_for(params.merge(page: 1))}>; rel="first") unless records.first_page?
        links << %(<#{url_for(params.merge(page: records.prev_page))}>; rel="prev") unless records.first_page?
        response.headers['Link'] = links.join(', ')
      end

      def current_user
        return unless request.headers['Authorization'] =~ /\ABearer\s+(.*)\Z/
        token = UserApiToken.eager_load(:user).find_by(token: Regexp.last_match(1))
        token&.user
      end

      def authenticate_user!
        return if current_user.present?
        raise E2eTester::NotAuthenticated
      end
    end
  end
end
