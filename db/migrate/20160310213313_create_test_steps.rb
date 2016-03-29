class CreateTestSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :test_steps do |t|
      t.string :type, null: false, index: true
      t.references :test, null: false, index: true
      t.integer :position, null: true, index: true
      t.text :data, null: true

      t.timestamps

      t.foreign_key :tests
    end
  end
end
