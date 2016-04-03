require 'rails_helper'

RSpec.describe Admin::ProjectsController, type: :controller do
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:projects) { create_list :project, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:project) { create :project }
    it 'renders successfully' do
      get :show, params: { id: project }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
end
