class CreateUserApiTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :user_api_tokens do |t|
      t.references :user
      t.string :name, null: false, index: true
      t.string :token, null: false, index: { unique: true }

      t.foreign_key :users

      t.timestamps
    end
  end
end
