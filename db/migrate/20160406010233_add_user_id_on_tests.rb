class AddUserIdOnTests < ActiveRecord::Migration[5.0]
  def up
    change_table :tests do |t|
      t.references :user, null: true, index: true
      t.foreign_key :users
    end
    execute <<-EOS
      UPDATE tests LEFT JOIN projects ON tests.project_id = projects.id
      SET tests.user_id = projects.user_id
    EOS
    change_column :tests, :user_id, :integer, null: false, index: true
  end

  def down
    remove_foreign_key :tests, :users
    remove_index :tests, :user_id
    remove_column :tests, :user_id
  end
end
