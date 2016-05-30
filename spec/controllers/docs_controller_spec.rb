require 'rails_helper'

RSpec.describe DocsController, type: :controller do
  render_views

  describe 'GET api' do
    context 'with signed in user' do
      include_context 'with signed in user'
      it 'renders successfully' do
        get :api

        expect(response.status).to be 200
        expect(response).to render_template('docs/api')
      end
    end
    context 'without signed in user' do
      include_context 'without signed in user'
      it 'renders successfully' do
        get :api

        expect(response.status).to be 200
        expect(response).to render_template('docs/api')
      end
    end
  end
end
