module Api
  class BaseController < ActionController::API
    include Rails.application.routes.url_helpers

    def self.inherited(base)
      base.class_eval do
        include Swagger::Blocks
      end
    end

    rescue_from Exception do |e|
      logger.error "#{e.message}  #{e.backtrace.join("\n  ")}"
      render json: { messages: [e.message] }, status: 500
    end
  end
end
