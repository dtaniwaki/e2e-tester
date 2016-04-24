require 'rails_helper'

RSpec.describe Admin::BrowsersController, type: :controller do
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:browsers) { create_list :browser, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:browser) { create :browser }
    it 'renders successfully' do
      get :show, params: { id: browser }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
  describe 'POST enable' do
    let!(:browser) { create :browser, disabled: true }
    it 'renders successfully' do
      expect do
        post :enable, params: { id: browser }
      end.to change { browser.reload.disabled }.from(true).to(false)

      expect(response.status).to be 302
      expect(response).to redirect_to admin_browser_path(browser)
    end
  end
  describe 'POST disable' do
    let!(:browser) { create :browser, disabled: false }
    it 'renders successfully' do
      expect do
        post :disable, params: { id: browser }
      end.to change { browser.reload.disabled }.from(false).to(true)

      expect(response.status).to be 302
      expect(response).to redirect_to admin_browser_path(browser)
    end
  end
end
