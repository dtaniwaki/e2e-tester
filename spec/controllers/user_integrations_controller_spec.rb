require 'rails_helper'

RSpec.describe UserIntegrationsController, type: :controller do
  describe 'GET index' do
    let!(:integrations) { create_list :slack_integration, 2 }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :index

        expect(response.status).to be 200
        expect(response).to render_template('user_integrations/index')
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :index

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
