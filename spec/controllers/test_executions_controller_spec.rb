require 'rails_helper'

RSpec.describe TestExecutionsController, type: :controller do
  render_views

  let(:test) { create :test }
  let!(:test_version) { create :test_version, test: test }
  describe 'GET index' do
    let!(:test_executions) { create_list :test_execution, 2, test_version: test_version }
    context 'with signed in user' do
      include_context 'with signed in user'
      let!(:my_test_executions) { create_list :test_execution, 1, test_version: test_version, user: current_user }
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :index, params: { test_id: test, num: test_version.position }

          expect(response.status).to be 200
          expect(response).to render_template('test_executions/index')
          expect(assigns(:test_executions)).to match_array(test_executions + my_test_executions)
        end
      end
      context 'with accessible test_version' do
        before do
          create :user_test_version, user: current_user, test_version: test_version
        end
        it 'renders successfully' do
          get :index, params: { test_id: test, num: test_version.position }

          expect(response.status).to be 200
          expect(response).to render_template('test_executions/index')
          expect(assigns(:test_executions)).to match_array(my_test_executions)
        end
      end
      context 'with inaccessible test_version' do
        it 'renders successfully' do
          expect do
            get :index, params: { test_id: test, num: test_version.position }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :index, params: { test_id: test, num: test_version.position }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET show' do
    let!(:test_execution) { create :test_execution, test_version: test_version }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        let!(:test_execution) { create :test_execution, test_version: test_version, user: current_user }
        it 'renders successfully' do
          get :show, params: { id: test_execution }

          expect(response.status).to be 200
          expect(response).to render_template('test_executions/show')
        end
      end
      context 'with inaccessible test_execution' do
        it 'renders successfully' do
          expect do
            get :show, params: { id: test_execution }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :show, params: { id: test_execution }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
      context 'with token' do
        let!(:share) { create :test_execution_share, test_execution: test_execution }
        context 'with valid token' do
          it 'renders successfully' do
            get :show, params: { id: test_execution, token: share.token }

            expect(response.status).to be 200
            expect(response).to render_template('test_executions/show')
          end
        end
        context 'without valid token' do
          it 'renders successfully' do
            expect do
              get :show, params: { id: test_execution, token: share.token + '-invalid' }
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end
    end
  end
  describe 'POST create' do
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_version' do
        before do
          create :user_test_version, user: current_user, test_version: test_version
        end
        it 'renders successfully' do
          post :create, params: { test_id: test, num: test_version.position }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_execution_path(test_version.test_executions.last))
        end
      end
      context 'with inaccessible test_execution' do
        it 'renders successfully' do
          expect do
            post :create, params: { test_id: test, num: test_version.position }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { test_id: test, num: test_version.position }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET done' do
    let!(:test_execution) { create :test_execution, test_version: test_version }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_execution' do
        let!(:test_execution) { create :test_execution, test_version: test_version, user: current_user }
        it 'renders successfully' do
          get :done, params: { id: test_execution }, format: :json

          expect(response.status).to be 200
          expect(response).to render_template('test_executions/done')
        end
      end
      context 'with inaccessible test_execution' do
        it 'renders successfully' do
          expect do
            get :done, params: { id: test_execution }, format: :json
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :done, params: { id: test_execution }, format: :json

        expect(response.status).to be 401
      end
    end
  end
end
