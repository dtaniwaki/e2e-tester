class UserTest < ApplicationRecord
  belongs_to :user, inverse_of: :user_tests
  belongs_to :assigned_by, class_name: 'User', foreign_key: 'assigned_by_id', inverse_of: :assigned_test_users
  belongs_to :test, inverse_of: :user_tests
  has_many :user_test_variables, inverse_of: :user_test, dependent: :destroy

  scope :with_user, ->(user) { where(user_id: user.is_a?(ActiveRecord::Base) ? user.id : user) }
  scope :with_test, ->(test) { where(test_id: test.is_a?(ActiveRecord::Base) ? test.id : test) }

  after_commit :send_notification!, on: :create, if: ->(ut) { ut.assigned_by.present? }

  accepts_nested_attributes_for :user_test_variables, allow_destroy: true

  def send_notification!
    UserMailer.assigned_test(self).deliver_now!
  end
end
