class MakeTestsSti < ActiveRecord::Migration[5.0]
  def up
    add_column :tests, :type, :string, null: true, index: false
    execute <<-EOS
      UPDATE tests SET type = 'Test';
    EOS
    change_column :tests, :type, :string, null: false, index: true
    change_column :tests, :project_id, :integer, null: true, index: true

    rename_table :tests, :test_step_sets

    # Remove relevant foreign keys first
    remove_foreign_key :test_step_sets, column: :test_id
    remove_foreign_key :test_steps, column: :test_id
    rename_column :test_step_sets, :test_id, :test_step_set_id
    rename_column :test_steps, :test_id, :test_step_set_id
    add_foreign_key :test_step_sets, :test_step_sets
    add_foreign_key :test_steps, :test_step_sets
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "You can't rollback this migration because it will break the consistency of the tests.project_id condition"
  end
end
