ActiveAdmin.register Test do
  menu parent: 'Test'

  scope :all, default: true
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

  show do |test|
    attributes_table do
      test.attribute_names.each do |name|
        if name == 'test_version_id'
          row name do |p|
            link_to p.test_version_id, admin_test_path(p.test_version_id) if p.test_version_id.present?
          end
        else
          row name
        end
      end
    end
    panel 'Tests' do
      table_for test.test_versions do
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
