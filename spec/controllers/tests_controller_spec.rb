require 'rails_helper'

RSpec.describe TestsController, type: :controller do
  render_views

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
end
