require 'rails_helper'

RSpec.describe UserNotificationSettingsController, type: :controller do
  describe 'GET index' do
    context 'global settings' do
      let!(:settings) { create_list :user_notification_setting, 2 }
      context 'with signed in user' do
        include_context 'with signed in user'
        it 'renders successfully' do
          get :index

          expect(response.status).to be 200
          expect(response).to render_template('user_notification_settings/index')
          expect(response).to render_template('user_notification_settings/_global_settings')
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
    context 'integration settings' do
      let(:user_integration) { create :slack_integration, user: current_user }
      let!(:settings) { create_list :user_notification_setting, 2, user: user_integration.user, user_integration: user_integration }
      context 'with signed in user' do
        include_context 'with signed in user'
        it 'renders successfully' do
          get :index, params: { user_integration_id: user_integration.to_param }

          expect(response.status).to be 200
          expect(response).to render_template('user_notification_settings/index')
          expect(response).to render_template('user_notification_settings/_integration_settings')
        end
      end
      context 'without signed in user' do
        include_context 'without signed in user'
        it 'renders successfully' do
          get :index, params: { user_integration_id: user_integration.to_param }

          expect(response.status).to be 302
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
    context 'test settings' do
      let(:test) { create :test }
      let!(:settings) { create_list :user_notification_setting, 2, user: current_user, test: test }
      context 'with signed in user' do
        include_context 'with signed in user'
        it 'renders successfully' do
          get :index, params: { test_id: test.to_param }

          expect(response.status).to be 200
          expect(response).to render_template('user_notification_settings/index')
          expect(response).to render_template('user_notification_settings/_test_settings')
        end
      end
      context 'without signed in user' do
        include_context 'without signed in user'
        it 'renders successfully' do
          get :index, params: { test_id: test.to_param }

          expect(response.status).to be 302
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end
  describe 'POST create' do
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        expect do
          post :create, params: { user_notification_setting: { notify_test_execution_result: nil } }
        end.to change { current_user.user_notification_settings.count }.from(0).to(1)

        expect(response.status).to be 302
        expect(response).to redirect_to(user_notification_settings_path)
      end
      context 'with user test' do
        let(:test) { create :test }
        it 'renders successfully' do
          expect do
            post :create, params: { test_id: test.to_param, user_notification_setting: { notify_test_execution_result: nil } }
          end.to change { current_user.user_notification_settings.with_test(test).count }.from(0).to(1)

          expect(response.status).to be 302
          expect(response).to redirect_to(user_notification_settings_path)
        end
      end
      context 'with user integration' do
        let(:user_integration) { create :slack_integration, user: current_user }
        it 'renders successfully' do
          expect do
            post :create, params: { user_integration_id: user_integration.to_param, user_notification_setting: { notify_test_execution_result: nil } }
          end.to change { current_user.user_notification_settings.with_user_integration(user_integration).count }.from(0).to(1)

          expect(response.status).to be 302
          expect(response).to redirect_to(user_notification_settings_path)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        expect do
          post :create, params: { user_notification_setting: { notify_test_execution_result: nil } }
        end.not_to change { current_user.user_notification_settings.count }.from(0)

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT update' do
    let!(:setting) { create :user_notification_setting, user: current_user }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'redirects successfully' do
        put :update, params: { id: setting.to_param, user_notification_setting: { notify_test_execution_result: nil } }

        expect(response.status).to be 302
        expect(response).to redirect_to(user_notification_settings_path)
      end
      context 'for inaccessible setting' do
        let!(:setting) { create :user_notification_setting }
        it 'redirects successfully' do
          expect do
            put :update, params: { id: setting.to_param, user_notification_setting: { notify_test_execution_result: nil } }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { id: setting.to_param }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
