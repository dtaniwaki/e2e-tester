class AddDeletedAtOnTestStepSets < ActiveRecord::Migration[5.0]
  def change
    change_table :test_step_sets do |t|
      t.datetime :deleted_at, null: true, index: true
    end
  end
end
