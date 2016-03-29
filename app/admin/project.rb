ActiveAdmin.register Project do
  permit_params :title

  scope :with_deleted
  scope :only_deleted

  index do
    selectable_column
    id_column
    column :title
    column :created_at
    column :updated_at
    actions
  end

  show do |project|
    attributes_table do
      project.attribute_names.each do |name|
        if name == 'test_id'
          row name do |p|
            link_to p.test_id, admin_test_path(p.test_id)
          end
        else
          row name
        end
      end
    end
    panel 'Tests' do
      table_for project.tests do
        column :id do |t|
          link_to t.id, admin_test_path(t)
        end
        column :created_at do |t|
          link_to t.created_at, admin_test_path(t)
        end
      end
    end
    active_admin_comments
  end
end
