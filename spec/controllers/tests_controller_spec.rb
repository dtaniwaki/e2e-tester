require 'rails_helper'

RSpec.describe TestsController, type: :controller do
  let(:browser) { create :browser }
  let(:updating_test_params) do
    {
      updating_test_versions_attributes: {
        '0': {
          title: 'updating',
          description: 'bar',
          test_steps_attributes: {
            '0': {
              test_step_type: 'none'
            }
          },
          browser_ids: [browser.id]
        }
      }
    }
  end

  describe 'GET index' do
    let!(:tests) { create_list :test, 2 }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :index

        expect(response.status).to be 200
        expect(response).to render_template('tests/index')
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
  describe 'GET show' do
    let!(:test) { create :test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :show, params: { id: test }

          expect(response.status).to be 200
          expect(response).to render_template('tests/show')
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            get :show, params: { id: test }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :show, params: { id: test }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET new' do
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :new

        expect(response.status).to be 200
        expect(response).to render_template('tests/new')
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :new

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'POST create' do
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        expect do
          post :create, params: { test: updating_test_params }
        end.to change { current_user.tests.count }.from(0).to(1)

        expect(response.status).to be 302
        expect(response).to redirect_to(test_path(current_user.tests.last))
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { test: updating_test_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET edit' do
    let!(:test) { create :test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :edit, params: { id: test }

          expect(response.status).to be 200
          expect(response).to render_template('tests/edit')
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            get :edit, params: { id: test }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :edit, params: { id: test }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT update' do
    let!(:test) { create :test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          expect do
            put :update, params: { id: test, test: updating_test_params }
          end.to change { test.test_versions.count }.from(1).to(2)

          expect(response.status).to be 302
          expect(response).to redirect_to(test_path(test))
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            put :update, params: { id: test, test: updating_test_params }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { id: test, test: updating_test_params }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'DELETE destroy' do
    let!(:test) { create :test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          expect do
            delete :destroy, params: { id: test }
          end.to change { current_user.accessible_tests.count }.from(1).to(0)

          expect(response.status).to be 302
          expect(response).to redirect_to(tests_path)
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            delete :destroy, params: { id: test }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        delete :destroy, params: { id: test }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
