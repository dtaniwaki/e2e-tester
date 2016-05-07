ActiveAdmin.register TestVersion do
  menu parent: 'Test'

  permit_params

  actions :all, except: [:new]

  controller do
    def scoped_collection
      super.includes :user, :test, :base_test_step_set
    end
  end

  index do
    selectable_column
    id_column
    column(:user_id) { |t| link_to t.user.name, admin_user_path(t.user) }
    column(:test_id) { |t| link_to t.test.id, admin_test_path(t.test) }
    column(:base_test_step_set_id) { |t| auto_link(t.base_test_step_set, t.base_test_step_set.title) if t.base_test_step_set.present? }
    column :created_at
    column :updated_at
    actions
  end

  show do |test_version|
    attributes_table do
      test_version.attribute_names.each do |name|
        case name
        when 'user_id'
          row name do |t|
            link_to t.user.name, admin_user_path(t.user)
          end
        when 'test_id'
          row name do |t|
            link_to t.test.id, admin_test_path(t.test)
          end
        when 'base_test_step_set_id'
          row name do |t|
            if t.base_test_step_set.present?
              auto_link(t.base_test_step_set, t.base_test_step_set.title) if t.base_test_step_set.present?
            end
          end
        else
          row name
        end
      end
    end
    panel 'Test Steps' do
      table_for test_version.test_steps do
        column :id
        column :to_line, &:to_line
      end
    end
    panel 'Browsers' do
      table_for test_version.browsers do
        column :id do |b|
          link_to b.id, admin_browser_path(b)
        end
        column :name do |b|
          link_to b.name, admin_browser_path(b)
        end
      end
    end
    active_admin_comments
  end
end
