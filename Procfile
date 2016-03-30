init: DATABASE_URL=$CLEARDB_DATABASE_URL bundle exec rails db:create db:migrate db:seed
web: DATABASE_URL=$CLEARDB_DATABASE_URL bundle exec puma -C config/puma.rb
worker: DATABASE_URL=$CLEARDB_DATABASE_URL bundle exec sidekiq -C config/sidekiq.yml
