ActiveAdmin.register SharedTestStepSet do
  menu parent: 'Test', label: SharedTestStepSet.model_name.human.humanize

  permit_params

  actions :all, except: [:new]

  controller do
    def scoped_collection
      super.includes :user, :base_test_step_set
    end
  end

  index do
    selectable_column
    id_column
    column(:user_id) { |e| link_to e.user.name, admin_user_path(e.user) }
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
        when 'base_test_step_set_id'
          row name do |t|
            auto_link(t.base_test_step_set, t.base_test_step_set.title) if t.base_test_step_set.present?
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
    active_admin_comments
  end
end
