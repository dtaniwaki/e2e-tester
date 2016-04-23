require 'rails_helper'

RSpec.describe TestStepSetsController, type: :controller do
  render_views

  describe 'GET index' do
    let!(:test_step_sets) { create_list :shared_test_step_set, 2 }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :index

        expect(response.status).to be 200
        expect(response).to render_template('test_step_sets/index')
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
    let!(:test_step_set) { create :shared_test_step_set }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_step_set' do
        let!(:user_shared_test_step_set) { create :user_shared_test_step_set, user: current_user, shared_test_step_set: test_step_set }
        it 'renders successfully' do
          get :show, params: { id: test_step_set }

          expect(response.status).to be 200
          expect(response).to render_template('test_step_sets/show')
        end
      end
      context 'with inaccessible test_step_set' do
        it 'renders successfully' do
          expect do
            get :show, params: { id: test_step_set }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :show, params: { id: test_step_set }

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
        expect(response).to render_template('test_step_sets/new')
      end
      context 'with base_test_step_set' do
        let!(:base_test_step_set) { create :shared_test_step_set }
        context 'with accessible test_step_set' do
          let!(:user_shared_test_step_set) { create :user_shared_test_step_set, shared_test_step_set: base_test_step_set, user: current_user }
          it 'renders successfully' do
            get :new, params: { base_test_step_set_id: base_test_step_set }

            expect(response.status).to be 200
            expect(response).to render_template('test_step_sets/new')
          end
        end
        context 'with inaccessible test_step_set' do
          it 'renders successfully' do
            expect do
              get :new, params: { base_test_step_set_id: base_test_step_set }
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
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
    let(:test_step_set_attributes) { attributes_for(:shared_test_step_set).merge(test_steps_attributes: build(:test_step).to_line) }
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        expect do
          post :create, params: { test_step_set: test_step_set_attributes }
        end.to change { current_user.accessible_shared_test_step_sets.count }.from(0).to(1)

        expect(response.status).to be 302
        expect(response).to redirect_to(test_step_set_path(current_user.test_step_sets.last))
      end
      context 'with base_test_step_set' do
        let!(:base_test_step_set) { create :shared_test_step_set }
        context 'with accessible test_step_set' do
          let!(:user_shared_test_step_set) { create :user_shared_test_step_set, shared_test_step_set: base_test_step_set, user: current_user }
          it 'renders successfully' do
            expect do
              post :create, params: { test_step_set: test_step_set_attributes, base_test_step_set_id: base_test_step_set }
            end.to change { current_user.accessible_shared_test_step_sets.count }.from(1).to(2)

            expect(response.status).to be 302
            expect(response).to redirect_to(test_step_set_path(current_user.test_step_sets.last))
            expect(current_user.test_step_sets.last.base_test_step_set).to eq base_test_step_set
          end
        end
        context 'with inaccessible test_step_set' do
          it 'renders successfully' do
            expect do
              post :create, params: { test_step_set: test_step_set_attributes, base_test_step_set_id: base_test_step_set }
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        post :create, params: { test_step_set: test_step_set_attributes }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET edit' do
    let!(:test_step_set) { create :shared_test_step_set }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_step_set' do
        let!(:user_shared_test_step_set) { create :user_shared_test_step_set, shared_test_step_set: test_step_set, user: current_user }
        it 'renders successfully' do
          get :edit, params: { id: test_step_set }

          expect(response.status).to be 200
          expect(response).to render_template('test_step_sets/edit')
        end
      end
      context 'with inaccessible test_step_set' do
        it 'renders successfully' do
          expect do
            get :edit, params: { id: test_step_set }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :edit, params: { id: test_step_set }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT update' do
    let(:test_step_set_attributes) { attributes_for(:shared_test_step_set) }
    let!(:test_step_set) { create :shared_test_step_set }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_step_set' do
        let!(:user_shared_test_step_set) { create :user_shared_test_step_set, shared_test_step_set: test_step_set, user: current_user }
        it 'renders successfully' do
          expect do
            put :update, params: { id: test_step_set, test_step_set: test_step_set_attributes }
          end.not_to change { current_user.accessible_shared_test_step_sets.count }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_step_set_path(test_step_set))
        end
      end
      context 'with inaccessible test_step_set' do
        it 'renders successfully' do
          expect do
            put :update, params: { id: test_step_set, test_step_set: test_step_set_attributes }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        put :update, params: { id: test_step_set, test_step_set: test_step_set_attributes }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'DELETE destroy' do
    let!(:test_step_set) { create :shared_test_step_set }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_step_set' do
        before do
          create :user_shared_test_step_set, user: current_user, shared_test_step_set: test_step_set
        end
        it 'renders successfully' do
          delete :destroy, params: { id: test_step_set }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_step_sets_path)
        end
      end
      context 'with inaccessible test_step_set' do
        it 'renders successfully' do
          expect do
            delete :destroy, params: { id: test_step_set }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        delete :destroy, params: { id: test_step_set }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
