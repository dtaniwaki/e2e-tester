source 'https://rubygems.org'

ruby '2.4.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use mysql2 as the database for Active Record
gem 'mysql2', '~> 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 3.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.0.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.1.0'
gem 'jquery-ui-rails', '~> 5.0.5'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
gem 'jbuilder', github: 'rails/jbuilder', branch: :master # To use with rails-api
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'fog-aws', '~> 0.9.0'
gem 'fog-local', '~> 0.3.0'
gem 'paperclip', '~> 5.1.0'
# gem 'poltergeist'
gem 'activeadmin', '~> 1.0.0.pre4'
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml', ref: 'dd9c0acf26aab111ebc647cd8deb99ebc6946531'
gem 'acts_as_hashids', '~> 0.1.2'
gem 'acts_as_list', '~> 0.7.2'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bower-rails', '~> 0.10.0'
gem 'bugsnag', '~> 4.0.0'
gem 'cocoon', '~> 1.2.9'
gem 'config', '~> 1.1.0'
gem 'devise', '~> 4.2.0'
gem 'devise_invitable', '~> 1.6.0'
gem 'draper', github: 'audionerd/draper', branch: 'rails5', ref: 'e816e0e5876b76c648c0928f1c3f2aa2c7a3d1f2'
gem 'enum_help', '~> 0.0.15'
gem 'faraday', '~> 0.9.2'
gem 'faraday_middleware', '~> 0.10.0'
gem 'gravatar_image_tag', '~> 1.2.0'
gem 'mini_magick', '~> 4.5.1'
gem 'nilify_blanks', '~> 1.2.1'
gem 'omniauth', '~> 1.3.2'
gem 'omniauth-google-oauth2', '~> 0.4.1'
gem 'paranoia', github: 'rubysherpas/paranoia', branch: 'core'
gem 'pry-rails', '~> 0.3.4'
gem 'pundit', '~> 1.1.0'
gem 'rack-cors', '~> 0.4.0', require: 'rack/cors'
gem 'redcarpet', '~> 3.2.3'
gem 'redis-namespace', '~> 1.5.2'
gem 'redis-rails', '~> 5.0.1'
gem 'selenium-webdriver', '~> 2.53.0'
gem 'sidekiq', '~> 4.2.9'
gem 'sidekiq-failures', '~> 0.4.5'
gem 'sidekiq-unique-jobs', '~> 4.0.13'
gem 'simple_form', '~> 3.2.1'
gem 'sinatra', '~> 1.0', require: nil
gem 'slim-rails', '~> 3.1.1'
gem 'sprockets-es6', '~> 0.9.2'
gem 'swagger-blocks', '~> 1.3.3'
gem 'validates_timeliness', '~> 4.0.2'
gem 'yajl-ruby', '~> 1.3.0'

################################
# activeadmin Rails 5 support
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources'
################################

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 8.2.2'
  gem 'factory_girl_rails', '~> 4.6.0'
  gem 'pry-byebug', '~> 3.3.0'
  # i18n generators
  gem 'i18n-tasks', '~> 0.9.5'
  gem 'i18n_generators', '~> 2.1.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '~> 3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.6.4'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Code regulation
  gem 'rubocop', '~> 0.47.1', require: false
  gem 'rubocop-rspec', '~> 1.10.0', require: false
  # Vulnerability scan
  gem 'brakeman', '~> 3.2.1', require: false
  # Debug Email
  gem 'letter_opener_web', '~> 1.3.0'
end

group :test do
  gem 'rails-controller-testing', '~> 0.1.1'
  gem 'rspec-rails', '~> 3.5.0.beta2'
  # Test Coverage
  gem 'codeclimate-test-reporter', '~> 0.5.0', require: false
  gem 'coveralls', '~> 0.8.13', require: false
  gem 'database_rewinder', '~> 0.5.3'
  gem 'simplecov', '~> 0.11.2', require: false
  # gem 'fuubar'
  gem 'timecop', '~> 0.8.0'
  gem 'webmock', '~> 1.24.2', require: false
  # gem 'guard-rspec', require: false
  gem 'vcr', '~> 3.0.1'
  # Mock Redis
  gem 'fakeredis', '~> 0.5.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
