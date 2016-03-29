class CreateTestStepExecutions < ActiveRecord::Migration[5.0]
  def change
    create_table :test_step_executions do |t|
      t.references :test_step, null: false, index: true
      t.references :test_execution_browser, null: false, index: true
      t.integer :state, null: false, default: 0
      t.text :message

      t.timestamps

      t.index [:test_step_id, :test_execution_browser_id], unique: true, name: 'index_test_step_id_and_test_execution_browser_id'

      t.foreign_key :test_steps
      t.foreign_key :test_execution_browsers
    end
  end
end
