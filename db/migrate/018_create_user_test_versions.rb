class CreateUserTestVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_test_versions do |t|
      t.references :user, null: false, index: true
      t.references :assigned_by, null: true, index: true
      t.references :test_version, null: false, index: true

      t.index [:user_id, :test_version_id], unique: true

      t.timestamps

      t.foreign_key :users
      t.foreign_key :users, column: :assigned_by_id
      t.foreign_key :test_step_sets, column: :test_version_id
    end
  end
end
