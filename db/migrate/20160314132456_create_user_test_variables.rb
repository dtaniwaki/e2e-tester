class CreateUserTestVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :user_test_variables do |t|
      t.references :user_test, null: false, index: true
      t.string :name, null: false, limit: 128
      t.string :value, null: true

      t.timestamps

      t.index [:user_test_id, :name], unique: true

      t.foreign_key :user_tests
    end
  end
end
