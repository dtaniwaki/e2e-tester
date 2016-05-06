class CreateUserCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :user_credentials do |t|
      t.string :type, null: false, index: true
      t.references :user, null: false, index: true
      t.text :data, null: true

      t.foreign_key :users

      t.timestamps
    end
  end
end
