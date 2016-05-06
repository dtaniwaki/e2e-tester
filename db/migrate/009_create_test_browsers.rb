class CreateTestBrowsers < ActiveRecord::Migration[5.0]
  def change
    create_table :test_browsers do |t|
      t.references :test_version, null: false, index: true
      t.references :browser, null: false, index: true

      t.index [:test_version_id, :browser_id], unique: true

      t.timestamps

      t.foreign_key :test_step_sets, column: :test_version_id
      t.foreign_key :browsers
    end
  end
end
