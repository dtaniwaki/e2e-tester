require 'bugsnag/sidekiq'

Sidekiq.configure_server do |config|
  config.redis = Settings.redis.sidekiq_server.to_hash
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
end

Sidekiq.configure_client do |config|
  config.redis = Settings.redis.sidekiq_client.to_hash
end

Sidekiq.default_worker_options = { backtrace: true }
