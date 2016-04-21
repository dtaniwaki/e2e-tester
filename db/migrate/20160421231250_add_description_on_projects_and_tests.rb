class AddDescriptionOnProjectsAndTests < ActiveRecord::Migration[5.0]
  def change
    change_table :projects do |t|
      t.text :description, null: true
    end
    change_table :test_step_sets do |t|
      t.text :description, null: true
    end
  end
end
