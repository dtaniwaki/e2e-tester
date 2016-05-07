require 'rails_helper'

RSpec.describe Admin::SharedTestStepSetsController, type: :controller do
  include_context 'with signed in admin user'
  describe 'GET index' do
    let!(:shared_test_step_sets) { create_list :shared_test_step_set, 2 }
    it 'renders successfully' do
      get :index

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/index')
    end
  end
  describe 'GET show' do
    let!(:shared_test_step_set) { create :shared_test_step_set }
    it 'renders successfully' do
      get :show, params: { id: shared_test_step_set }

      expect(response.status).to be 200
      expect(response).to render_template('active_admin/resource/show')
    end
  end
end
