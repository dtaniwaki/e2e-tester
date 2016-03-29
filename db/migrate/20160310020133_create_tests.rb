class CreateTests < ActiveRecord::Migration[5.0]
  def change
    create_table :tests do |t|
      t.references :project, null: false, index: true
      t.references :test, null: true, index: true

      t.timestamps

      t.foreign_key :projects
    end
    add_foreign_key :projects, :tests
    add_foreign_key :tests, :tests
  end
end
