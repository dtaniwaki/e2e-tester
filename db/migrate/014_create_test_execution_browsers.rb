class CreateTestExecutionBrowsers < ActiveRecord::Migration[5.0]
  def change
    create_table :test_execution_browsers do |t|
      t.references :test_execution, null: false, index: true
      t.references :test_browser, null: false, index: true
      t.integer :state, null: false, default: 0
      t.string :error, null: true

      t.timestamps

      t.index [:test_execution_id, :test_browser_id], unique: true, name: 'index_test_execution_id_and_test_browser_id'

      t.foreign_key :test_executions
      t.foreign_key :test_browsers
    end
  end
end
