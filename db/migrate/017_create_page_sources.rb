class CreatePageSources < ActiveRecord::Migration[5.0]
  def change
    create_table :page_sources do |t|
      t.references :test_step, null: false, index: true
      t.references :test_step_execution, null: false, index: true
      t.attachment :source

      t.index [:test_step_id, :test_step_execution_id], unique: true, name: 'index_test_step_id_and_test_step_execution_id'

      t.timestamps

      t.foreign_key :test_steps
      t.foreign_key :test_step_executions
    end
  end
end
