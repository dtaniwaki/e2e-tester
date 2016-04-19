ActiveAdmin.register Test do
  permit_params

  index do
    selectable_column
    id_column
    column :created_at
    column :updated_at
    actions
  end

  show do |test_step_set|
    attributes_table do
      test_step_set.attribute_names.each do |name|
        if name == 'test_step_set_id'
          row name do |p|
            link_to p.test_step_set_id, admin_test_step_set_path(p.test_step_set_id) if p.test_step_set_id.present?
          end
        else
          row name
        end
      end
    end
    panel 'Test Steps' do
      table_for test_step_set.test_steps do
        column :id
        column :to_line, &:to_line
      end
    end
    panel 'Browsers' do
      table_for test_step_set.browsers do
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
