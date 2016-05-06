require 'rails_helper'

RSpec.describe TestVersionsController, type: :controller do
  render_views

  describe 'GET index' do
    let(:test) { create :test }
    let!(:test_versions) { create_list :test_version, 2, test: test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test' do
        let!(:user_test) { create :user_test, user: current_user, test: test }
        it 'renders successfully' do
          get :index, params: { test_id: test }

          expect(response.status).to be 200
          expect(response).to render_template('test_versions/index')
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
  describe 'GET show' do
    let(:test) { create :test }
    let!(:test_version) { create :test_version, test: test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_version' do
        let!(:user_test_version) { create :user_test_version, user: current_user, test_version: test_version }
        it 'renders successfully' do
          get :show, params: { test_id: test, num: test_version.position }

          expect(response.status).to be 200
          expect(response).to render_template('test_versions/show')
        end
      end
      context 'with inaccessible test_version' do
        it 'renders successfully' do
          expect do
            get :show, params: { test_id: test, num: test_version.position }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :show, params: { test_id: test, num: test_version.position }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'DELETE destroy' do
    let(:test) { create :test }
    let!(:test_version) { create :test_version, test: test }
    context 'with signed in user' do
      include_context 'with signed in user'
      context 'with accessible test_version' do
        let!(:user_test) { create :user_test, user: current_user, test: test }
        it 'renders successfully' do
          delete :destroy, params: { test_id: test, num: test_version.position }

          expect(response.status).to be 302
          expect(response).to redirect_to(test_test_versions_path(test))
        end
      end
      context 'with inaccessible test_version' do
        it 'renders successfully' do
          expect do
            delete :destroy, params: { test_id: test, num: test_version.position }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        delete :destroy, params: { test_id: test, num: test_version.position }

        expect(response.status).to be 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
