require 'rails_helper'

RSpec.describe AdminUsers::OmniauthCallbacksController, type: :controller do
  describe 'GET google_oauth2' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        raw_info: {
          email: 'foo-google@example.com',
          email_verified: 'true',
          family_name: 'Taniwaki',
          gender: 'male',
          given_name: 'Daisuke',
          hd: 'example.com',
          locale: 'en',
          name: 'Daisuke Taniwaki'
        },
        info: {
          email: 'foo-google@example.com',
          first_name: 'Daisuke',
          last_name: 'Taniwaki',
          image: '',
          name: 'Daisuke Taniwaki'
        },
        provider: 'google_oauth2',
        uid: 'hoge'
      )
    end
    before do
      request.env['devise.mapping'] = Devise.mappings[:admin_user]
      request.env['omniauth.auth'] = auth
    end
    context 'new admin_user' do
      it 'renders successfully' do
        expect do
          get :google_oauth2
        end.to change { AdminUser.count }.from(0).to(1)

        expect(response.status).to be 302
        expect(response).to redirect_to admin_dashboard_path
        expect(controller.current_admin_user).to be_a AdminUser
      end
    end
    context 'existing admin_user' do
      let!(:admin_user) { create :admin_user, email: 'foo-google@example.com' }
      it 'renders successfully' do
        expect do
          get :google_oauth2
        end.not_to change { AdminUser.count }.from(1)

        expect(response.status).to be 302
        expect(response).to redirect_to admin_dashboard_path
        expect(controller.current_admin_user).to eq admin_user
      end
    end
  end
end
