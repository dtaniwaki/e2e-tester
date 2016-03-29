class CreateUserProjectVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :user_project_variables do |t|
      t.references :user_project, null: false, index: true
      t.string :name, null: false, limit: 128
      t.string :value, null: true

      t.timestamps

      t.index [:user_project_id, :name], unique: true

      t.foreign_key :user_projects
    end
  end
end
