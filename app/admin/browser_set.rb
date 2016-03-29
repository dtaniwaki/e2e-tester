ActiveAdmin.register BrowserSet do
  permit_params :name, browser_ids: []

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs 'BrowserSet' do
      f.input :name
    end
    f.inputs 'Browsers' do
      local_browsers = Browser::Local.all
      if local_browsers.present?
        f.input :browsers, label: 'PhantomJS', as: :check_boxes, collection: local_browsers, label_html: { style: 'float: left; margin-right: 10px;' }
      end
      Browser::Browserstack.all.group_by { |b| "#{b.os} #{b.os_version}" }.each do |g, browsers|
        f.input :browsers, label: g, as: :check_boxes, collection: browsers
      end
    end
    f.actions
  end

  show do |browser_set|
    attributes_table do
      browser_set.attribute_names.each do |name|
        row name
      end
    end
    panel 'Browsers' do
      table_for browser_set.browsers do
        column :id do |browser|
          link_to browser.id, admin_browser_path(browser)
        end
        column :type
        column :name do |browser|
          link_to browser.name, admin_browser_path(browser)
        end
      end
    end
    active_admin_comments
  end
end
