require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:users) { create_list :user, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:user) { create :user }
    it 'renders successfully' do
      get :show, params: { id: user }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
end
