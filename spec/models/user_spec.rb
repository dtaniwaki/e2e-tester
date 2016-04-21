require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create :user }
  let!(:user_variables) { create :user_variable, user: user, name: 'foo', value: 'user_variable' }
  let(:user_project) { create :user_project, user: user }
  let!(:user_project_variables) { create :user_project_variable, user_project: user_project, name: 'wow', value: 'user_project_variable' }
  let(:user_test) { create :user_test, test: test, user: user }
  let!(:user_test_variables) { create :user_test_variable, user_test: user_test, name: 'bar', value: 'user_test_variable' }
  let(:test) { create :test, project: user_project.project }
  describe '#variables' do
    it 'returns the merged variables' do
      expect(subject.variables(test)).to eq({ foo: 'user_variable', bar: 'user_test_variable', wow: 'user_project_variable' }.with_indifferent_access)
    end
    context 'confliction between user_variables and user_project_variables' do
      let!(:user_project_variables) { create :user_project_variable, user_project: user_project, name: 'foo', value: 'user_project_variable' }
      it 'returns the merged variables' do
        expect(subject.variables(test)).to eq({ foo: 'user_project_variable', bar: 'user_test_variable' }.with_indifferent_access)
      end
    end
    context 'confliction between user_variables and user_test_variables' do
      let!(:user_test_variables) { create :user_test_variable, user_test: user_test, name: 'foo', value: 'user_test_variable' }
      it 'returns the merged variables' do
        expect(subject.variables(test)).to eq({ foo: 'user_test_variable', wow: 'user_project_variable' }.with_indifferent_access)
      end
    end
    context 'confliction between user_variables, user_project_variables and user_test_variables' do
      let!(:user_project_variables) { create :user_project_variable, user_project: user_project, name: 'foo', value: 'user_project_variable' }
      let!(:user_test_variables) { create :user_test_variable, user_test: user_test, name: 'foo', value: 'user_test_variable' }
      it 'returns the merged variables' do
        expect(subject.variables(test)).to eq({ foo: 'user_test_variable' }.with_indifferent_access)
      end
    end
  end
end
