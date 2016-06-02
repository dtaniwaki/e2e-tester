class UserTestVariable < ApplicationRecord
  belongs_to :user_test, inverse_of: :user_test_variables

  scope :with_user, ->(user) { joins(:user_test).merge(UserTest.where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user)) }
  scope :with_test, ->(test) { joins(:user_test).merge(UserTest.where(test_id: test.is_a?(ActiveRecord::Base) ? test.id : test)) }

  validates :name, length: { minimum: 0, maximum: 20 }, allow_nil: true
  validates :value, length: { minimum: 0, maximum: 255 }, allow_nil: true
  validates :name, uniqueness: { scope: [:user_test_id] }, presence: true
  validates_with SimilarRecordValidator, count: 10, conditions: [:user_test_id]
end
