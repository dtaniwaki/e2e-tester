class CreateUserVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :user_variables do |t|
      t.references :user, null: false, index: true
      t.string :name, null: false, limit: 128
      t.string :value, null: true

      t.timestamps

      t.index [:user_id, :name], unique: true

      t.foreign_key :users
    end
  end
end
