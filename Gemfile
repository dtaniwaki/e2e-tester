source 'https://rubygems.org'

ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta3', '< 5.1'
# Use mysql2 as the database for Active Record
gem 'mysql2', '~> 0.4.3'
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
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'paperclip', '~> 5.0.0.beta1'
gem 'fog-aws', '~> 0.9.0'
gem 'fog-local', '~> 0.3.0'
# gem 'poltergeist'
gem 'selenium-webdriver', '~> 2.53.0'
gem 'faraday', '~> 0.9.2'
gem 'faraday_middleware', '~> 0.10.0'
gem 'mini_magick', '~> 4.5.1'
gem 'pry-rails', '~> 0.3.4'
gem 'config', '~> 1.1.0'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'devise', '~> 4.0.0.rc1'
gem 'devise_invitable', github: 'scambra/devise_invitable', branch: 'master'
gem 'sidekiq', '~> 4.1.0'
gem 'sidekiq-unique-jobs', '~> 4.0.13'
gem 'sidekiq-failures', '~> 0.4.5'
gem 'yajl-ruby', '~> 1.2.1'
gem 'sinatra', github: 'sinatra/sinatra', require: nil
gem 'redis-namespace', '~> 1.5.2'
gem 'omniauth', '~> 1.3.1'
gem 'omniauth-google-oauth2', '~> 0.3.1'
gem 'sprockets-es6', '~> 0.9.0'
gem 'acts_as_list', '~> 0.7.2'
gem 'paranoia', github: 'rubysherpas/paranoia', branch: 'core'
gem 'slim-rails', '~> 3.0.1'
gem 'pundit', '~> 1.1.0'
gem 'bugsnag', '~> 4.0.0'
gem 'redcarpet', '~> 3.2.3'
gem 'gravatar_image_tag', '~> 1.2.0'
gem 'simple_form', '~> 3.2.1'
gem 'cocoon', '~> 1.2.9'
gem 'nilify_blanks', '~> 1.2.1'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'bower-rails', '~> 0.10.0'

################################
# redis-rails Rails 5 support
# gem 'redis-rack', github: "schuylr/redis-rack", ref: "a01bfe5a8ee1df4af6c3a886e005896fe711aab7"
gem 'redis-rack', github: 'redis-store/redis-rack', ref: '83a7b7b895bb528c1ae88329e4bca09a97d9fbbf'
gem 'redis-activesupport', github: 'claudiob/redis-activesupport', ref: 'd83917b3a852a98cd0bee8709ab52e5437f7ca11'
# gem 'redis-actionpack', github: "schuylr/redis-actionpack", ref: "b4b37571e3db63cf10713995e7d1ef85e3183b42"
gem 'redis-actionpack', github: 'marcroberts/redis-actionpack', ref: '4e23b49c814ee49ed216bbcaa7811f55c84b5cd2'
gem 'redis-rails', github: 'redis-store/redis-rails', branch: :master
################################

################################
# ActiveAdmin Rails 5 support
gem 'activeadmin', github: 'activeadmin/activeadmin', branch: 'master'
gem 'ransack',    github: 'activerecord-hackery/ransack'
gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
gem 'formtastic', github: 'justinfrench/formtastic'
gem 'draper',     github: 'audionerd/draper', branch: 'rails5', ref: 'e816e0e587'
# To fix a Draper deprecation error
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
################################

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 8.2.2'
  gem 'pry-byebug', '~> 3.3.0'
  gem 'factory_girl_rails', '~> 4.6.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.6.4'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Code regulation
  gem 'rubocop', '~> 0.37.2', require: false
  gem 'rubocop-rspec', '~> 1.4.0', require: false
  # Vulnerability scan
  gem 'brakeman', '~> 3.2.1', require: false
  # Debug Email
  gem 'letter_opener_web', '~> 1.3.0'
end

group :test do
  gem 'rspec-rails', '~> 3.5.0.beta2'
  gem 'rails-controller-testing', '~> 0.1.1'
  # Test Coverage
  gem 'simplecov', '~> 0.11.2', require: false
  gem 'coveralls', '~> 0.8.13', require: false
  gem 'codeclimate-test-reporter', '~> 0.5.0', require: false
  gem 'database_rewinder', '~> 0.5.3'
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
