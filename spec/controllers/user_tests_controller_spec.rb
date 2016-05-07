require 'rails_helper'

RSpec.describe UserTestsController, type: :controller do
  render_views

  describe 'POST create' do
    let!(:test) { create :test }
    let(:invitee) { create :user }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          expect do
            post :create, params: { test_id: test, email: invitee.email }
          end.to change { invitee.accessible_tests.reload.include?(test) }.from(false).to(true)

          expect(response.status).to be 302
          expect(response).to redirect_to(test_path(test))
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            post :create, params: { test_id: test, email: invitee.email }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { test_id: test, email: invitee.email }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT update' do
    let(:variable_params) do
      {
        user_test_variables_attributes: {
          '0': {
            name: 'foo',
            value: 'bar'
          }
        }
      }
    end
    let!(:test) { create :test }
    let!(:user_test) { create :user_test, test: test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        let!(:user_test) { create :user_test, user: current_user, test: test }
        it 'renders successfully' do
          put :update, params: { id: user_test, user_test: variable_params }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_path(test))
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            put :update, params: { id: user_test, user_test: variable_params }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { id: user_test, user_test: variable_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET index' do
    let!(:test) { create :test }
    let!(:user_test1) { create :user_test, test: test }
    let!(:user_test2) { create :user_test, test: test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :index, params: { test_id: test }

          expect(response.status).to be 200
          expect(response).to render_template('user_tests/index')
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            get :index, params: { test_id: test }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :index, params: { test_id: test }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
