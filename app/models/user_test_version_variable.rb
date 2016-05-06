class UserTestVersionVariable < ApplicationRecord
  belongs_to :user_test_version, inverse_of: :user_test_version_variables

  scope :with_user, ->(user) { joins(:user_test_version).merge(UserTestVersion.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }
  scope :with_test_version, lambda { |test_version|
    joins(:user_test_version).merge(UserTestVersion.where(test_version_id: test_version.is_a?(ActiveRecord::Base) ? test_version.id : test_version))
  }

  validates :name, :value, length: { minimum: 0, maximum: 255 }, allow_nil: true
  validates :name, uniqueness: { scope: [:user_test_version_id] }, presence: true
end
