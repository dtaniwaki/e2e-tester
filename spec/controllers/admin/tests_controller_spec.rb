require 'rails_helper'

RSpec.describe Admin::TestsController, type: :controller do
  render_views
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:tests) { create_list :test, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:test) { create :test }
    it 'renders successfully' do
      get :show, params: { id: test }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
end
