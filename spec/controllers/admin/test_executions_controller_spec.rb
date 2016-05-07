require 'rails_helper'

RSpec.describe Admin::TestExecutionsController, type: :controller do
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:test_executions) { create_list :test_execution, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:test_execution) { create :test_execution }
    it 'renders successfully' do
      get :show, params: { id: test_execution }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
end
