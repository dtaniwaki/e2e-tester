module UserIntegration
  class Base < ApplicationRecord
    include SerializedAttribute
    include NotifiableConcern

    self.table_name = 'user_integrations'

    belongs_to :user, inverse_of: :user_integrations
    has_many :user_notification_settings, inverse_of: :user_integration, foreign_key: 'user_integration_id'

    validates :name, length: { maximum: 100 }, presence: true

    before_validation :reset_last_error, if: :data_changed?

    def self.policy_class
      UserIntegrationPolicy
    end

    def notify!(name, *args)
      public_send(name, *args)
      self.last_error = nil
      save!
    rescue => e
      logger.warn "#{e.message}\n  #{e.backtrace.join("\n  ")}"
      self.last_error = e.message
      save!
    end

    def notify?(name, test = nil)
      name = "notify_#{name}"
      user_notification_settings.detect { |us| us.test == test }&.public_send(name) ||
        user_notification_settings.detect { |us| us.test.nil? }&.public_send(name) ||
        user_notification_settings.defaults[name]
    end

    def test_execution_result(_test_execution)
      raise NotImplementedError
    end

    private

    def reset_last_error
      self.last_error = nil
    end
  end
end
