class CreateTestStepSets < ActiveRecord::Migration[5.0]
  def change
    create_table :test_step_sets do |t|
      t.references :test, null: true, index: true
      t.references :base_test_step_set, null: true, index: true
      t.references :user, null: false, index: true
      t.string :type, null: true, index: true
      t.integer :position, null: true, index: true
      t.datetime :deleted_at, null: true, index: true
      t.string :title, null: false
      t.text :description, null: true

      t.timestamps

      t.foreign_key :tests
      t.foreign_key :users
    end
    add_foreign_key :test_step_sets, :test_step_sets, column: :base_test_step_set_id
    change_table :tests do |t|
      t.references :current_test_version, null: true, index: true
      t.foreign_key :test_step_sets, column: :current_test_version_id
    end
  end
end
