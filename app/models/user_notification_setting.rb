class UserNotificationSetting < ApplicationRecord
  belongs_to :user, inverse_of: :user_notification_settings
  belongs_to :test, inverse_of: :user_notification_settings
  belongs_to :user_integration, inverse_of: :user_notification_settings, class_name: 'UserIntegration::Base'

  scope :with_test, ->(test) { where(test_id: test.is_a?(ActiveRecord::Base) ? test.id : test) }
  scope :with_user_integration, ->(user_integration) { where(user_integration_id: user_integration.is_a?(ActiveRecord::Base) ? user_integration.id : user_integration) }

  validates :user_id, uniqueness: { scope: [:test_id, :user_integration_id] }

  enum notify_test_execution_result: { all_tests: 1, only_self: 2, never: 3 }

  def self.defaults
    @defaults ||= HashWithIndifferentAccess.new(
      notify_test_execution_result: 'all_tests'
    ).freeze
  end
end
