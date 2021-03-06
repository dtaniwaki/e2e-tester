class TestBrowser < ApplicationRecord
  belongs_to :test_version, inverse_of: :test_browsers
  belongs_to :browser, class_name: 'Browser::Base', inverse_of: :test_browsers
  has_many :test_execution_browsers, inverse_of: :test_browser
end
