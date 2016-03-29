class BrowserSet < ApplicationRecord
  has_many :browser_browser_sets, inverse_of: :browser_set, dependent: :destroy
  has_many :browsers, through: :browser_browser_sets

  validates :name, length: { maximum: 255 }, presence: true
end
