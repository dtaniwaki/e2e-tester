class AddSharedTestStepSetIdOnTestSteps < ActiveRecord::Migration[5.0]
  def change
    change_table :test_steps do |t|
      t.references :shared_test_step_set, null: true, index: true

      t.foreign_key :test_step_sets, column: 'shared_test_step_set_id'
    end
  end
end
