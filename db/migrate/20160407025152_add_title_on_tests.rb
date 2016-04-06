class AddTitleOnTests < ActiveRecord::Migration[5.0]
  def change
    change_table :tests do |t|
      t.string :title, null: true
    end
  end
end
