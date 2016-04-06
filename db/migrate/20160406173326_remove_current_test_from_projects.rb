class RemoveCurrentTestFromProjects < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key :projects, :tests
    remove_column :projects, :test_id
  end

  def down
    add_column :projects, :test_id, :integer, null: true, index: true
    add_foreign_key :projects, :tests
  end
end
