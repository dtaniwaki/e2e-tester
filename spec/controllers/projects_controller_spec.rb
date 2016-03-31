require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'GET index' do
    let!(:projects) { create_list :project, 2 }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :index

        expect(response.status).to be 200
        expect(response).to render_template('projects/index')
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
    let!(:project) { create :project }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible project' do
        before do
          create :user_project, user: current_user, project: project
        end
        it 'renders successfully' do
          get :show, params: { id: project }

          expect(response.status).to be 200
          expect(response).to render_template('projects/show')
        end
      end
      context 'with inaccessible project' do
        it 'renders successfully' do
          expect do
            get :show, params: { id: project }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :show, params: { id: project }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
