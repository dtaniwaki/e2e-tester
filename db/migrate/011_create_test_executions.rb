class CreateTestExecutions < ActiveRecord::Migration[5.0]
  def change
    create_table :test_executions do |t|
      t.references :user, null: false, index: true
      t.references :test_version, null: false, index: true
      t.integer :state, null: false, default: 0
      t.datetime :deleted_at, null: true, index: true

      t.index [:user_id, :test_version_id]

      t.timestamps

      t.foreign_key :users
      t.foreign_key :test_step_sets, column: :test_version_id
    end
  end
end
