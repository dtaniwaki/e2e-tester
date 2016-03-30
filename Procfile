init: DATABASE_URL=$(echo -n $CLEARDB_DATABASE_URL | sed 's/mysql:/mysql2:/') bundle exec rails db:create db:migrate db:seed
web: DATABASE_URL=$(echo -n $CLEARDB_DATABASE_URL | sed 's/mysql:/mysql2:/') bundle exec puma -C config/puma.rb
worker: DATABASE_URL=$(echo -n $CLEARDB_DATABASE_URL | sed 's/mysql:/mysql2:/') bundle exec sidekiq -C config/sidekiq.yml
