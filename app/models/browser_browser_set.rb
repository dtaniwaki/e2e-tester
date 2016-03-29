class BrowserBrowserSet < ApplicationRecord
  belongs_to :browser, inverse_of: :browser_browser_sets, class_name: 'Browser::Base'
  belongs_to :browser_set, inverse_of: :browser_browser_sets
end
