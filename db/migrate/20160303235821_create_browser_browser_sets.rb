class CreateBrowserBrowserSets < ActiveRecord::Migration[5.0]
  def change
    create_table :browser_browser_sets do |t|
      t.references :browser, null: false, index: true
      t.references :browser_set, null: false, index: true

      t.index [:browser_set_id, :browser_id], unique: true

      t.timestamps
    end
  end
end
