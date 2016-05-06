class DeviseCreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string :provider
      t.string :uid
      t.string :name
      t.string :token

      t.timestamps null: false
    end

    add_index :admin_users, :email, unique: true
  end
end
