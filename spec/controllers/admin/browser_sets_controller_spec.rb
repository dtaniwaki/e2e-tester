require 'rails_helper'

RSpec.describe Admin::BrowserSetsController, type: :controller do
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:browser_sets) { create_list :browser_set, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:browser_set) { create :browser_set }
    it 'renders successfully' do
      get :show, params: { id: browser_set }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
  describe 'GET new' do
    it 'renders successfully' do
      get :new

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/new')
    end
  end
  describe 'GET edit' do
    let!(:browser_set) { create :browser_set }
    it 'renders successfully' do
      get :edit, params: { id: browser_set }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/edit')
    end
  end
end
