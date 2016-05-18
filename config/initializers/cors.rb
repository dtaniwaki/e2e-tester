Rails.application.configure do
  config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
    allow do
      origins '*'
      resource '/api/*', headers: :any, methods: [:get, :post, :delete, :put, :patch, :options, :head]
    end
  end
end
