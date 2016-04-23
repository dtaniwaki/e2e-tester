require 'rails_helper'

RSpec.describe MiscController, type: :controller do
  render_views

  describe 'GET tests' do
    let!(:tests) { create_list :test, 2 }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :tests

        expect(response.status).to be 200
        expect(response).to render_template('misc/tests')
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :tests

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
