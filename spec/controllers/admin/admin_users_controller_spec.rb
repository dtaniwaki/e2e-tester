require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:admin_users) { create_list :admin_user, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:admin_user) { create :admin_user }
    it 'renders successfully' do
      get :show, params: { id: admin_user }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
  describe 'GET new' do
    let!(:admin_user) { create :admin_user }
    it 'renders successfully' do
      get :new

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/new')
    end
  end
  describe 'GET edit' do
    let!(:admin_user) { create :admin_user }
    it 'renders successfully' do
      get :edit, params: { id: admin_user }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/edit')
    end
  end
end
