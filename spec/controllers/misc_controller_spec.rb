require 'rails_helper'

RSpec.describe MiscController, type: :controller do
  render_views

  describe 'GET assigned_tests' do
    let!(:assigned_tests) { create_list :test_version, 2 }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :assigned_tests

        expect(response.status).to be 200
        expect(response).to render_template('misc/assigned_tests')
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :assigned_tests

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
