require 'rails_helper'

RSpec.describe UserTestVersionsController, type: :controller do
  render_views

  describe 'POST create' do
    let!(:test_version) { create :test_version }
    let(:invitee) { create :user }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test_version.test
        end
        it 'renders successfully' do
          expect do
            post :create, params: { test_version_id: test_version, email: invitee.email }
          end.to change { invitee.accessible_test_versions.reload.include?(test_version) }.from(false).to(true)

          expect(response.status).to be 302
          expect(response).to redirect_to(test_test_version_path(test_version.test, test_version.position))
        end
      end
      context 'with inaccessible test_version' do
        it 'renders successfully' do
          expect do
            post :create, params: { test_version_id: test_version, email: invitee.email }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { test_version_id: test_version, email: invitee.email }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT update' do
    let(:variable_params) do
      {
        user_test_version_variables_attributes: {
          '0': {
            name: 'foo',
            value: 'bar'
          }
        }
      }
    end
    let!(:test) { create :test }
    let!(:test_version) { create :test_version, test: test }
    let!(:user_test_version) { create :user_test_version, test_version: test_version }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        let!(:user_test_version) { create :user_test_version, user: current_user, test_version: test_version }
        it 'renders successfully' do
          put :update, params: { id: user_test_version, user_test_version: variable_params }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_test_version_path(test_version.test, test_version.position))
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            put :update, params: { id: user_test_version, user_test_version: variable_params }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { id: user_test_version, user_test_version: variable_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET index' do
    let!(:test) { create :test }
    let!(:test_version) { create :test_version, test: test }
    let!(:user_test_version1) { create :user_test_version, test_version: test_version }
    let!(:user_test_version2) { create :user_test_version, test_version: test_version }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :index, params: { test_version_id: test_version }

          expect(response.status).to be 200
          expect(response).to render_template('user_test_versions/index')
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            get :index, params: { test_version_id: test_version }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :index, params: { test_version_id: test_version }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
