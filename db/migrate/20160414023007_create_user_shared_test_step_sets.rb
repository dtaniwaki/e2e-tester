class CreateUserSharedTestStepSets < ActiveRecord::Migration[5.0]
  def change
    create_table :user_shared_test_step_sets do |t|
      t.references :user, null: false, index: true
      t.references :shared_test_step_set, null: false, index: true

      t.index [:user_id, :shared_test_step_set_id], unique: true, name: 'index_user_shared_test_step_sets_on_user_n_shared_test_step_set'
      t.foreign_key :users
      t.foreign_key :test_step_sets, column: 'shared_test_step_set_id'

      t.timestamps
    end
  end
end
