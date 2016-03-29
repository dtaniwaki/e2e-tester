ActiveAdmin.register Browser::Base, as: 'browser' do
  scope :active
  scope :inactive

  permit_params :name, :device, :os, :os_version, :browser, :browser_version, :disabled, :deprecated

  index do
    selectable_column
    id_column
    column :type
    column :name
    column :device
    column :os
    column :os_version
    column :browser
    column :browser_version
    column :disabled
    column :deprecated
    actions
  end

  action_item :update_browsers, only: [:index] do
    link_to 'Update Browsers', update_browsers_admin_browsers_path, method: :post
  end

  batch_action :enable do |ids|
    Browser::Base.where(id: ids).update_all disabled: false
    flash[:notice] = "Successfully enabled Browser#{ids.map { |id| "##{id}" }.join(', ')}"
    redirect_to :back
  end

  batch_action :disable do |ids|
    Browser::Base.where(id: ids).update_all disabled: true
    flash[:notice] = "Successfully disabled Browser#{ids.map { |id| "##{id}" }.join(', ')}"
    redirect_to :back
  end

  member_action :enable do |b|
    b.update_attributes!(disabled: false)
    flash[:notice] = "Successfully enabled Browser\##{b.id}"
    redirect_to :back
  end

  member_action :disable do |b|
    b.update_attributes!(disabled: true)
    flash[:notice] = "Successfully disabled Browser\##{b.id}"
    redirect_to :back
  end

  collection_action :update_browsers, method: :post do
    UpdateBrowsersJob.perform_async [:browserstack, :local]
    flash[:notice] = 'Successfully registered an update test'
    redirect_to :back
  end

  show do |browser|
    attributes_table do
      browser.attribute_names.each do |name|
        row name
      end
    end
    panel 'Browser Sets' do
      table_for browser.browser_sets do
        column :id do |browser_set|
          link_to browser_set.id, admin_browser_set_path(browser_set)
        end
        column :name do |browser_set|
          link_to browser_set.name, admin_browser_set_path(browser_set)
        end
      end
    end
    active_admin_comments
  end
end
