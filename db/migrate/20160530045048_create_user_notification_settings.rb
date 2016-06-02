class CreateUserNotificationSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_notification_settings do |t|
      t.references :user, null: false, index: true
      t.references :test, null: true, index: true
      t.references :user_integration, null: true, index: true
      t.integer :notify_test_execution_result

      t.index [:user_id, :test_id, :user_integration_id], unique: true, name: 'index_user_notification_settings'

      t.foreign_key :users
      t.foreign_key :tests
      t.foreign_key :user_integrations

      t.timestamps
    end
  end
end
