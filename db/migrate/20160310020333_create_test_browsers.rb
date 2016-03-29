class CreateTestBrowsers < ActiveRecord::Migration[5.0]
  def change
    create_table :test_browsers do |t|
      t.references :test, null: false, index: true
      t.references :browser, null: false, index: true

      t.index [:test_id, :browser_id], unique: true

      t.timestamps

      t.foreign_key :tests
      t.foreign_key :browsers
    end
  end
end
