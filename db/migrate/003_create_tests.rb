class CreateTests < ActiveRecord::Migration[5.0]
  def change
    create_table :tests do |t|
      t.references :user, null: true, index: true
      t.datetime :deleted_at, null: true, index: true

      t.timestamps

      t.foreign_key :users
    end
  end
end
