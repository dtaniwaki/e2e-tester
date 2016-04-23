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
  describe 'GET new' do
    let(:project) { create :project }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        let!(:user_project) { create :user_project, user: current_user, project: project }
        it 'renders successfully' do
          get :new, params: { project_id: project }

          expect(response.status).to be 200
          expect(response).to render_template('tests/new')
        end
        context 'with base_test' do
          let!(:base_test) { create :test }
          context 'with accessible base test' do
            let!(:base_test) { create :test, project: project }
            it 'renders successfully' do
              get :new, params: { project_id: project, base_test_step_set_id: base_test }

              expect(response.status).to be 200
              expect(response).to render_template('tests/new')
            end
          end
          context 'with inaccessible base test' do
            it 'renders successfully' do
              expect do
                get :new, params: { project_id: project, base_test_step_set_id: base_test }
              end.to raise_error(Pundit::NotAuthorizedError)
            end
          end
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            get :new, params: { project_id: project }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :new, params: { project_id: project }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'POST create' do
    let(:test_attributes) { attributes_for(:test).merge(test_steps_attributes: build(:test_step).to_line, browser_ids: create_list(:browser, 1).map(&:id)) }
    let(:project) { create :project }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible project' do
        let!(:user_project) { create :user_project, user: current_user, project: project }
        it 'renders successfully' do
          expect do
            post :create, params: { project_id: project, test: test_attributes }
          end.to change { project.tests.count }.from(0).to(1)

          expect(response.status).to be 302
          expect(response).to redirect_to(test_path(project.tests.last))
        end
        context 'with base_test' do
          let!(:base_test) { create :test }
          context 'with accessible base test' do
            let!(:base_test) { create :test, project: project }
            it 'renders successfully' do
              expect do
                post :create, params: { project_id: project, test: test_attributes, base_test_step_set_id: base_test }
              end.to change { project.tests.count }.from(1).to(2)

              expect(response.status).to be 302
              expect(response).to redirect_to(test_path(project.tests.last))
              expect(project.tests.last.base_test_step_set).to eq base_test
            end
          end
          context 'with inaccessible base test' do
            it 'renders successfully' do
              expect do
                post :create, params: { project_id: project, test: test_attributes, base_test_step_set_id: base_test }
              end.to raise_error(Pundit::NotAuthorizedError)
            end
          end
        end
      end
      context 'with inaccessible project' do
        it 'renders successfully' do
          expect do
            post :create, params: { project_id: project, test: test_attributes }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { project_id: project, test: test_attributes }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET edit' do
    let(:project) { create :project }
    let!(:test) { create :test, project: project }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        let!(:user_project) { create :user_project, user: current_user, project: project }
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
    let(:project) { create :project }
    let(:test_attributes) { attributes_for(:test) }
    let!(:test) { create :test, project: project }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        let!(:user_project) { create :user_project, user: current_user, project: project }
        it 'renders successfully' do
          expect do
            put :update, params: { id: test, test: test_attributes }
          end.not_to change { project.tests.count }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_path(test))
        end
      end
      context 'with inaccessible test' do
        it 'renders successfully' do
          expect do
            put :update, params: { id: test, test: test_attributes }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { id: test, test: test_attributes }

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
