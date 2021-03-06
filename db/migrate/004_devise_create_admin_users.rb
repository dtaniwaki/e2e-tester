class DeviseCreateAdminUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.string :name, null: false, default: '', index: true
      t.string :email, null: false, default: '', index: { unique: true }
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token, index: { unique: true }
      t.datetime :reset_password_sent_at

      # Confirmable
      t.string   :confirmation_token, index: { unique: true }
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token, index: { unique: true }
      t.datetime :locked_at

      # Rememberable
      t.datetime :remember_created_at

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
