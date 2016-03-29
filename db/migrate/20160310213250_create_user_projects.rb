class CreateUserProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :user_projects do |t|
      t.references :user, null: false, index: true
      t.references :assigned_by, null: true, index: true
      t.references :project, null: false, index: true

      t.timestamps

      t.index [:user_id, :project_id], unique: true

      t.foreign_key :users
      t.foreign_key :users, column: :assigned_by_id
      t.foreign_key :projects
    end
  end
end
