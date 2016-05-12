require 'rails_helper'

RSpec.describe TestStepExecutionsController, type: :controller do
  render_views

  describe 'GET show' do
    let!(:test_version) { create :test_version }
    let!(:test_execution) { create :test_execution, test_version: test_version }
    let!(:test_step_execution1) { create :test_step_execution, test_execution: test_execution }
    let!(:test_step_execution2) { create :test_step_execution, test_execution: test_execution }
    let!(:test_step_execution3) { create :test_step_execution, test_execution: test_execution }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_step_execution' do
        let!(:test_execution) { create :test_execution, test_version: test_version, user: current_user }
        it 'renders successfully' do
          get :show, params: { id: test_step_execution1 }

          expect(response.status).to be 200
          expect(response).to render_template('test_step_executions/show')
        end
      end
      context 'with inaccessible test_step_execution' do
        it 'renders successfully' do
          expect do
            get :show, params: { id: test_step_execution1 }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :show, params: { id: test_step_execution1 }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
      context 'with token' do
        let!(:share) { create :test_execution_share, test_execution: test_execution }
        context 'with valid token' do
          it 'renders successfully' do
            get :show, params: { id: test_step_execution1, token: share.token }

            expect(response.status).to be 200
            expect(response).to render_template('test_step_executions/show')
          end
        end
        context 'without valid token' do
          it 'renders successfully' do
            expect do
              get :show, params: { id: test_step_execution1, token: share.token + '-invalid' }
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end
    end
  end
end
