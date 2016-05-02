class AddCurrentTestIdOnProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :test_id, :integer, null: true, index: true
  end
end
