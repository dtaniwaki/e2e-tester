class CreateUserTestVersionVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :user_test_version_variables do |t|
      t.references :user_test_version, null: false, index: true
      t.string :name, null: false, limit: 128
      t.string :value, null: true

      t.timestamps

      t.index [:user_test_version_id, :name], unique: true, name: 'index_on_user_test_version_and_name'

      t.foreign_key :user_test_versions
    end
  end
end
