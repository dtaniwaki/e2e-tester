class CreateTestExecutionShares < ActiveRecord::Migration[5.0]
  def change
    create_table :test_execution_shares do |t|
      t.references :user, index: true, null: false
      t.references :test_execution, index: true, null: false
      t.string :name, null: false
      t.string :token, null: false, index: { unique: true }
      t.datetime :expire_at, index: true

      t.foreign_key :users
      t.foreign_key :test_executions

      t.timestamps
    end
  end
end
