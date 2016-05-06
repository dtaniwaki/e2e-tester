require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create :user }
  let!(:user_variables) { create :user_variable, user: user, name: 'foo', value: 'user_variable' }
  let(:user_test) { create :user_test, user: user }
  let!(:user_test_variables) { create :user_test_variable, user_test: user_test, name: 'wow', value: 'user_test_variable' }
  let(:user_test_version) { create :user_test_version, test_version: test_version, user: user }
  let!(:user_test_version_variables) { create :user_test_version_variable, user_test_version: user_test_version, name: 'bar', value: 'user_test_version_variable' }
  let(:test_version) { create :test_version, test: user_test.test }
  describe '#variables' do
    it 'returns the merged variables' do
      expect(subject.variables(test_version)).to eq({ foo: 'user_variable', bar: 'user_test_version_variable', wow: 'user_test_variable' }.with_indifferent_access)
    end
    context 'confliction between user_variables and user_test_variables' do
      let!(:user_test_variables) { create :user_test_variable, user_test: user_test, name: 'foo', value: 'user_test_variable' }
      it 'returns the merged variables' do
        expect(subject.variables(test_version)).to eq({ foo: 'user_test_variable', bar: 'user_test_version_variable' }.with_indifferent_access)
      end
    end
    context 'confliction between user_variables and user_test_version_variables' do
      let!(:user_test_version_variables) { create :user_test_version_variable, user_test_version: user_test_version, name: 'foo', value: 'user_test_version_variable' }
      it 'returns the merged variables' do
        expect(subject.variables(test_version)).to eq({ foo: 'user_test_version_variable', wow: 'user_test_variable' }.with_indifferent_access)
      end
    end
    context 'confliction between user_variables, user_test_variables and user_test_version_variables' do
      let!(:user_test_variables) { create :user_test_variable, user_test: user_test, name: 'foo', value: 'user_test_variable' }
      let!(:user_test_version_variables) { create :user_test_version_variable, user_test_version: user_test_version, name: 'foo', value: 'user_test_version_variable' }
      it 'returns the merged variables' do
        expect(subject.variables(test_version)).to eq({ foo: 'user_test_version_variable' }.with_indifferent_access)
      end
    end
  end
end
