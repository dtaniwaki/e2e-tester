# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'

# Test Coverage
require 'codeclimate-test-reporter'
require 'coveralls'
require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 Coveralls::SimpleCov::Formatter,
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 CodeClimate::TestReporter::Formatter
                                                               ])
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'pundit/rspec'
require 'fakeredis/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
end
