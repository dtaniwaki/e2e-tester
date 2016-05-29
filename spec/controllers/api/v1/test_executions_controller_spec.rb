require 'rails_helper'

RSpec.describe Api::V1::TestExecutionsController, type: :controller do
  render_views

  let(:test) { create :test }
  let(:test_version) { create :test_version, test: test }
  before do
    request.headers['Accept'] = 'application/json'
  end
  describe 'GET index' do
    let!(:test_executions) { create_list :test_execution, 2, test_version: test_version }
    context 'with signed in user' do
      include_context 'with authorized token'
      let!(:my_test_executions) { create_list :test_execution, 1, test_version: test_version, user: current_user }
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :index, params: { test_id: test, number: test_version.position }

          expect(response.status).to be 200
          expect(JSON.parse(response.body)).to match_array((test_executions + my_test_executions).map { |te| hash_including('id' => te.to_param) })
        end
      end
      context 'with accessible test_version' do
        before do
          create :user_test_version, user: current_user, test_version: test_version
        end
        it 'renders successfully' do
          get :index, params: { test_id: test, number: test_version.position }

          expect(response.status).to be 200
          expect(JSON.parse(response.body)).to match_array(my_test_executions.map { |te| hash_including('id' => te.to_param) })
        end
      end
      context 'with inaccessible test_version' do
        it 'renders unauthorized' do
          get :index, params: { test_id: test, number: test_version.position }

          expect(response.status).to be 401
          expect(JSON.parse(response.body)).to eq('messages' => ['Unauthorized'])
        end
      end
    end
    context 'without signed in user' do
      include_context 'without authorized token'
      it 'renders forbidden' do
        get :index, params: { test_id: test, number: test_version.position }

        expect(response.status).to be 403
        expect(JSON.parse(response.body)).to eq('messages' => ['Forbidden'])
      end
    end
  end
  describe 'GET show' do
    let(:test_execution) { create :test_execution, test_version: test_version }
    context 'with signed in user' do
      include_context 'with authorized token'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          get :show, params: { id: test_execution }

          expect(response.status).to be 200
          expect(JSON.parse(response.body)).to match hash_including('id' => test_execution.to_param)
        end
      end
      context 'with accessible test_version' do
        before do
          create :user_test_version, user: current_user, test_version: test_version
        end
        it 'renders unauthorized' do
          get :show, params: { id: test_execution }

          expect(response.status).to be 401
          expect(JSON.parse(response.body)).to eq('messages' => ['Unauthorized'])
        end
      end
      context 'with inaccessible test_version' do
        it 'renders unauthorized' do
          get :show, params: { id: test_execution }

          expect(response.status).to be 401
          expect(JSON.parse(response.body)).to eq('messages' => ['Unauthorized'])
        end
      end
    end
    context 'without signed in user' do
      include_context 'without authorized token'
      it 'renders forbidden' do
        get :show, params: { id: test_execution }

        expect(response.status).to be 403
        expect(JSON.parse(response.body)).to eq('messages' => ['Forbidden'])
      end
    end
  end
  describe 'POST create' do
    context 'with signed in user' do
      include_context 'with authorized token'
      context 'with accessible test' do
        before do
          create :user_test, user: current_user, test: test
        end
        it 'renders successfully' do
          post :create, params: { test_id: test, number: test_version.position }

          expect(response.status).to be 201
          expect(JSON.parse(response.body)).to match hash_including('id')
        end
      end
      context 'with accessible test_version' do
        before do
          create :user_test_version, user: current_user, test_version: test_version
        end
        it 'renders successfully' do
          post :create, params: { test_id: test, number: test_version.position }

          expect(response.status).to be 201
          expect(JSON.parse(response.body)).to match hash_including('id')
        end
      end
      context 'with inaccessible test_version' do
        it 'renders unauthorized' do
          post :create, params: { test_id: test, number: test_version.position }

          expect(response.status).to be 401
          expect(JSON.parse(response.body)).to eq('messages' => ['Unauthorized'])
        end
      end
    end
    context 'without signed in user' do
      include_context 'without authorized token'
      it 'renders forbidden' do
        post :create, params: { test_id: test, number: test_version.position }

        expect(response.status).to be 403
        expect(JSON.parse(response.body)).to eq('messages' => ['Forbidden'])
      end
    end
  end
end
