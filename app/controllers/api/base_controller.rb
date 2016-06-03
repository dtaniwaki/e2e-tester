module Api
  class BaseController < ActionController::API
    include Rails.application.routes.url_helpers
    include ActionController::ImplicitRender
    include ActionView::Layouts
    include ActionController::Helpers

    def self.inherited(base)
      base.class_eval do
        include Swagger::Blocks
      end
    end

    rescue_from Exception, with: :internal_server_error
    [E2eTester::NotAuthenticated].each do |klass|
      rescue_from klass, with: :forbidden
    end
    [Pundit::NotAuthorizedError].each do |klass|
      rescue_from klass, with: :unauthorized
    end
    [E2eTester::NotFound, ActiveRecord::RecordNotFound].each do |klass|
      rescue_from klass, with: :not_found
    end

    protected

    def internal_server_error(exception)
      Bugsnag.auto_notify(exception)
      render_error exception, 'Internal server error', 500
    end

    def unauthorized(exception)
      render_error exception, 'Unauthorized', 401
    end

    def forbidden(exception)
      render_error exception, 'Forbidden', 403
    end

    def not_found(exception)
      render_error exception, 'Not found', 404
    end

    def render_error(exception, default_message, status)
      logger.error "#{exception.message}  #{exception.backtrace.join("\n  ")}"
      json = if Rails.application.config.consider_all_requests_local
        { messages: [exception.message], stacktrace: exception.backtrace }
      else
        { messages: [default_message] }
      end
      render body: json.to_json, status: status
    end
  end
end
