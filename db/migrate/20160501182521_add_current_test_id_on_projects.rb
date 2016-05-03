class AddCurrentTestIdOnProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :current_test_id, :integer, null: true, index: true
    remove_column :projects, :title
    remove_column :projects, :description
  end
end
