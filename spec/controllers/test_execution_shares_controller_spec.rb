require 'rails_helper'

RSpec.describe TestExecutionSharesController, type: :controller do
  render_views

  describe 'POST create' do
    let(:share_params) { { name: 'foo' } }
    let(:user) { current_user }
    let!(:test_execution) { create :test_execution, user: user }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        it 'renders successfully' do
          expect do
            post :create, params: { test_execution_id: test_execution, test_execution_share: share_params }
          end.to change { test_execution.test_execution_shares.count }.from(0).to(1)

          expect(response.status).to be 302
          expect(response).to redirect_to(test_execution_path(test_execution))
        end
      end
      context 'with inaccessible test_execution' do
        let(:user) { create :user }
        it 'renders successfully' do
          expect do
            post :create, params: { test_execution_id: test_execution, test_execution_share: share_params }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { test_execution_id: test_execution, test_execution_share: share_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT update' do
    let(:share_params) { { name: 'foo' } }
    let(:user) { current_user }
    let!(:test_execution) { create :test_execution, user: user }
    let!(:test_execution_share) { create :test_execution_share, test_execution: test_execution }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        let!(:test_execution_share) { create :test_execution_share, user: current_user, test_execution: test_execution }
        it 'renders successfully' do
          put :update, params: { id: test_execution_share, test_execution_share: share_params }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_execution_path(test_execution))
        end
      end
      context 'with inaccessible test_execution' do
        let(:user) { create :user }
        it 'renders successfully' do
          expect do
            put :update, params: { id: test_execution_share, test_execution_share: share_params }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { id: test_execution_share, test_execution_share: share_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET index' do
    let(:user) { current_user }
    let!(:test_execution) { create :test_execution, user: user }
    let!(:test_execution_share1) { create :test_execution_share, test_execution: test_execution }
    let!(:test_execution_share2) { create :test_execution_share, test_execution: test_execution }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        it 'renders successfully' do
          get :index, params: { test_execution_id: test_execution }

          expect(response.status).to be 200
          expect(response).to render_template('test_execution_shares/index')
        end
      end
      context 'with inaccessible test_execution' do
        let(:user) { create :user }
        it 'renders successfully' do
          expect do
            get :index, params: { test_execution_id: test_execution }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :index, params: { test_execution_id: test_execution }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'DELETE destroy' do
    let(:user) { current_user }
    let!(:test_execution) { create :test_execution, user: user }
    let!(:test_execution_share) { create :test_execution_share, test_execution: test_execution }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        let!(:test_execution_share) { create :test_execution_share, user: current_user, test_execution: test_execution }
        it 'renders successfully' do
          expect do
            delete :destroy, params: { id: test_execution_share }
          end.to change { TestExecutionShare.exists?(id: test_execution_share) }.from(true).to(false)

          expect(response.status).to be 302
          expect(response).to redirect_to(test_execution_path(test_execution))
        end
      end
      context 'with inaccessible test_execution' do
        let(:user) { create :user }
        it 'renders successfully' do
          expect do
            expect do
              delete :destroy, params: { id: test_execution_share }
            end.not_to change { TestExecutionShare.exists?(id: test_execution_share) }.from(true)
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        expect do
          delete :destroy, params: { id: test_execution_share }
        end.not_to change { TestExecutionShare.exists?(id: test_execution_share) }.from(true)

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
