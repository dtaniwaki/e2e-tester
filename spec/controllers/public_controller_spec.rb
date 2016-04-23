require 'rails_helper'

RSpec.describe PublicController, type: :controller do
  render_views

  describe 'GET root' do
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :root

        expect(response.status).to be 200
        expect(response).to render_template('public/root')
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :root

        expect(response.status).to be 200
        expect(response).to render_template('public/root')
      end
    end
  end
end
