ActiveAdmin.register Test do
  menu parent: 'Test', label: Test.model_name.human.humanize

  scope :all, default: true
  scope :with_deleted
  scope :only_deleted

  actions :all, except: [:new]

  controller do
    def scoped_collection
      super.includes :user, :current_test_version
    end
  end

  index do
    selectable_column
    id_column
    column(:user_id) { |t| link_to t.user.name, admin_user_path(t.user) }
    column(:curret_test_version_id) { |t| link_to t.current_test_version.id, admin_test_version_path(t.current_test_version) if t.current_test_version.present? }
    column :title
    column :created_at
    column :updated_at
    actions
  end

  show do |test|
    attributes_table do
      test.attribute_names.each do |name|
        case name
        when 'user_id'
          row name do |t|
            link_to t.user.name, admin_user_path(t.user)
          end
        when 'current_test_version_id'
          row name do |t|
            link_to t.current_test_version.id, admin_test_version_path(t.current_test_version) if t.current_test_version.present?
          end
        else
          row name
        end
      end
    end
    panel 'Test Versions' do
      table_for test.test_versions do
        column :id do |t|
          link_to t.id, admin_test_version_path(t)
        end
        column :position do |t|
          link_to t.position, admin_test_version_path(t)
        end
        column :current do |t|
          test.current_test_version == t ? 'Y' : ''
        end
        column :created_at do |t|
          link_to t.created_at, admin_test_version_path(t)
        end
      end
    end
    active_admin_comments
  end
end
