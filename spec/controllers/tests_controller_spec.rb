require 'rails_helper'

RSpec.describe TestsController, type: :controller do
  render_views

  describe 'GET index' do
    let(:project) { create :project }
    let!(:tests) { create_list :test, 2, project: project }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible project' do
        let!(:user_project) { create :user_project, user: current_user, project: project }
        it 'renders successfully' do
          get :index, params: { project_id: project }

          expect(response.status).to be 200
          expect(response).to render_template('tests/index')
        end
      end
      context 'with inaccessible project' do
        it 'renders successfully' do
          expect do
            get :index, params: { project_id: project }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :index, params: { project_id: project }

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
        let!(:user_test) { create :user_test, user: current_user, test: test }
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
  describe 'DELETE destroy' do
    let(:project) { create :project }
    let!(:test) { create :test, project: project }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        let!(:user_project) { create :user_project, user: current_user, project: project }
        it 'renders successfully' do
          delete :destroy, params: { id: test }

          expect(response.status).to be 302
          expect(response).to redirect_to(project_tests_path(project))
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
