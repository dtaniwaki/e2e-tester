module Api
  class BaseController < ActionController::API
    include Rails.application.routes.url_helpers

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
      logger.error "#{exception.message}  #{exception.backtrace.join("\n  ")}"
      render json: error_json(exception, 'Internal server error'), status: 500
    end

    def unauthorized(exception)
      logger.warn "#{exception.message}  #{exception.backtrace.join("\n  ")}"
      render json: error_json(exception, 'Unauthorized'), status: 401
    end

    def forbidden(exception)
      logger.warn "#{exception.message}  #{exception.backtrace.join("\n  ")}"
      render json: error_json(exception, 'Forbidden'), status: 403
    end

    def not_found(exception)
      logger.warn "#{exception.message}  #{exception.backtrace.join("\n  ")}"
      render json: error_json(exception, 'Not found'), status: 404
    end

    def error_json(exception, default_message)
      if Rails.application.config.consider_all_requests_local
        { messages: [exception.message], stacktrace: exception.backtrace }
      else
        { messages: [default_message] }
      end
    end
  end
end
