class CreateUserTests < ActiveRecord::Migration[5.0]
  def change
    create_table :user_tests do |t|
      t.references :user, null: false, index: true
      t.references :assigned_by, null: true, index: true
      t.references :test, null: false, index: true

      t.index [:user_id, :test_id], unique: true

      t.timestamps

      t.foreign_key :users
      t.foreign_key :users, column: :assigned_by_id
      t.foreign_key :tests
    end
  end
end
