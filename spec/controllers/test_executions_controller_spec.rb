require 'rails_helper'

RSpec.describe TestExecutionsController, type: :controller do
  let!(:test) { create :test }
  describe 'GET index' do
    let!(:test_executions) { create_list :test_execution, 2, test: test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :index, params: { test_id: test }

          expect(response.status).to be 200
          expect(response).to render_template('test_executions/index')
        end
      end
      context 'with inaccessible test_execution' do
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
  describe 'GET show' do
    let!(:test_execution) { create :test_execution, test: test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :show, params: { test_id: test, id: test_execution }

          expect(response.status).to be 200
          expect(response).to render_template('test_executions/show')
        end
      end
      context 'with inaccessible test_execution' do
        it 'renders successfully' do
          expect do
            get :show, params: { test_id: test, id: test_execution }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :show, params: { test_id: test, id: test_execution }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
