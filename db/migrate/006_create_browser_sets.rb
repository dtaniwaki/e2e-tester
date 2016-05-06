class CreateBrowserSets < ActiveRecord::Migration[5.0]
  def change
    create_table :browser_sets do |t|
      t.string :name, null: false, index: true
      t.boolean :disabled, null: false, default: false

      t.timestamps
    end
  end
end
