require 'rails_helper'

RSpec.describe BrowserstackCredentialsController, type: :controller do
  render_views

  describe 'POST create' do
    let(:browserstack_params) { { username: 'foo', password: 'bar' } }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        expect do
          post :create, params: { browserstack: browserstack_params }
        end.to change { current_user.reload.browserstack_credential.present? }.from(false).to(true)

        expect(response.status).to be 302
        expect(response).to redirect_to(user_credentials_path)
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { browserstack: browserstack_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT update' do
    let!(:browserstack_credential) { create :browserstack_credential, user: current_user, username: 'foo1', password: 'bar1' }
    let(:browserstack_params) { { username: 'foo2', password: 'bar2' } }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        expect do
          put :update, params: { browserstack: browserstack_params }
        end.not_to change { current_user.reload.browserstack_credential.present? }.from(true)

        expect(response.status).to be 302
        expect(response).to redirect_to(user_credentials_path)
        browserstack_credential.reload
        expect(browserstack_credential.username).to eq 'foo2'
        expect(browserstack_credential.password).to eq 'bar2'
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { browserstack: browserstack_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'DELETE destroy' do
    let!(:browserstack_credential) { create :browserstack_credential, user: current_user, username: 'foo1', password: 'bar1' }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        expect do
          delete :destroy
        end.to change { current_user.reload.browserstack_credential.present? }.from(true).to(false)

        expect(response.status).to be 302
        expect(response).to redirect_to(user_credentials_path)
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        delete :destroy

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
