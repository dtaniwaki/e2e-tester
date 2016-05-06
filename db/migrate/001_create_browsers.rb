class CreateBrowsers < ActiveRecord::Migration[5.0]
  def change
    create_table :browsers do |t|
      t.string :type, index: true
      t.string :device
      t.string :os
      t.string :os_version
      t.string :browser
      t.string :browser_version
      t.string :name
      t.boolean :disabled, null: false, default: false
      t.boolean :deprecated, null: false, default: false

      t.index [:disabled, :deprecated]
      t.index [:device, :os, :os_version, :browser, :browser_version], name: 'index_browser_types', length: { device: 32, os: 32, os_version: 32, browser: 32, browser_version: 32 }

      t.timestamps
    end
  end
end
