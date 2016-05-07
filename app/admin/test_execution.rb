ActiveAdmin.register TestExecution do
  menu parent: 'Test'

  permit_params

  actions :all, except: [:new]

  controller do
    def scoped_collection
      super.includes :user, :test_version
    end
  end

  index do
    selectable_column
    id_column
    column(:user_id) { |e| link_to e.user.name, admin_user_path(e.user) }
    column(:test_version_id) { |e| link_to e.test_version.title, admin_test_version_path(e.test_version) }
    column :state_i18n
    column :created_at
    column :updated_at
    actions
  end

  show do |execution|
    attributes_table do
      execution.attribute_names.each do |name|
        case name
        when 'user_id'
          row name do |e|
            link_to e.user.name, admin_user_path(e.user)
          end
        when 'test_version_id'
          row name do |e|
            link_to e.test_version.title, admin_test_version_path(e.test_version)
          end
        else
          row name
        end
      end
    end
    active_admin_comments
  end
end
