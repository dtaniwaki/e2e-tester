require 'rails_helper'

RSpec.describe Api::BaseController, type: :controller do
  controller do
    def index
      raise 'foo'
    end
  end

  describe 'rescue_from' do
    it 'returns 500 and the message in json' do
      get :index

      expect(response.status).to be 500
      expect(response.body).to eq %({"messages":["Internal server error"]})
    end
  end
end
