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

    rescue_from Exception, with: :handle_internal_server_error
    [E2eTester::NotAuthenticated].each do |klass|
      rescue_from klass, with: :handle_forbidden
    end
    [Pundit::NotAuthorizedError].each do |klass|
      rescue_from klass, with: :handle_unauthorized
    end
    [E2eTester::NotFound, ActiveRecord::RecordNotFound].each do |klass|
      rescue_from klass, with: :handle_not_found
    end

    protected

    def handle_internal_server_error(exception)
      Bugsnag.auto_notify(exception)
      render_error exception, 'Internal server error', 500
    end

    def handle_unauthorized(exception)
      render_error exception, 'Unauthorized', 401
    end

    def handle_forbidden(exception)
      render_error exception, 'Forbidden', 403
    end

    def handle_not_found(exception)
      render_error exception, 'Not found', 404
    end

    def render_error(exception, default_message, status)
      logger.error "#{exception.message}  #{exception.backtrace.join("\n  ")}"
      json = { messages: [default_message] }
      if Rails.application.config.consider_all_requests_local
        json[:exception] = { class: exception.class.to_s, message: exception.message, stacktrace: exception.backtrace }
      end
      render body: json.to_json, status: status
    end
  end
end
