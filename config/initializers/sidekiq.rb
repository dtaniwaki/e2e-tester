Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis.sidekiq.url, namespace: Settings.redis.sidekiq.namespace }
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
end

Sidekiq.configure_client do |config|
  config.redis = { url: Settings.redis.sidekiq.url, namespace: Settings.redis.sidekiq.namespace }
end

Sidekiq.default_worker_options = { backtrace: true }
