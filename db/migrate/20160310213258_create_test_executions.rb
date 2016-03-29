class CreateTestExecutions < ActiveRecord::Migration[5.0]
  def change
    create_table :test_executions do |t|
      t.references :user, null: false, index: true
      t.references :test, null: false, index: true
      t.integer :state, null: false, default: 0

      t.index [:user_id, :test_id]

      t.timestamps

      t.foreign_key :users
      t.foreign_key :tests
    end
  end
end
