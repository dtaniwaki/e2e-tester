class MakeTestsSti < ActiveRecord::Migration[5.0]
  def up
    add_column :tests, :type, :string, null: true, index: false
    execute <<-EOS
      UPDATE tests SET type = 'Test';
    EOS
    change_column :tests, :type, :string, null: false, index: true
    change_column :tests, :project_id, :integer, null: true, index: true
    rename_column :tests, :test_id, :test_step_set_id
    rename_table :tests, :test_step_sets
    rename_column :test_steps, :test_id, :test_step_set_id
  end

  def down
    rename_column :test_steps, :test_step_set_id, :test_id
    rename_table :test_step_sets, :tests
    rename_column :tests, :test_step_set_id, :test_id
    remove_column :tests, :type
    change_column :tests, :project_id, :integer, null: false, index: true
  end
end
