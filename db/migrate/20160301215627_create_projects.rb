class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :user, null: true, index: true
      t.references :test, null: true, index: true
      t.string :title, null: false, index: true
      t.datetime :deleted_at, null: true, index: true

      t.timestamps

      t.foreign_key :users
    end
  end
end
