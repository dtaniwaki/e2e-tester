class CreateActiveAdminComments < ActiveRecord::Migration[5.0]
  def change
    create_table :active_admin_comments do |t|
      t.string :namespace, index: true
      t.text   :body
      t.string :resource_id,   null: false
      t.string :resource_type, null: false
      t.references :author, polymorphic: true, index: true

      t.index [:resource_type, :resource_id]

      t.timestamps null: false
    end
  end
end
