class CreateUserIntegrations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_integrations do |t|
      t.references :user, null: false, index: true
      t.string :type, null: false, index: true
      t.string :name, null: false
      t.text :last_error
      t.text :data

      t.foreign_key :users

      t.timestamps
    end
  end
end
