class CreateTestSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :test_steps do |t|
      t.string :type, null: false, index: true
      t.references :test_step_set, null: false, index: true
      t.references :shared_test_step_set, null: true, index: true
      t.integer :position, null: true, index: true
      t.text :data, null: true

      t.timestamps

      t.foreign_key :test_step_sets
      t.foreign_key :test_step_sets, column: :shared_test_step_set_id
    end
  end
end
