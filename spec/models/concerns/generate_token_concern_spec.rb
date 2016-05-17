require 'rails_helper'

RSpec.describe GenerateTokenConcern, type: :model do
  subject(:test_execution_share) { build :test_execution_share }
  describe 'before_validation :assign_token, on: :create' do
    it 'assigns a token' do
      expect(subject.token).to be_nil
      subject.valid?
      expect(subject.token).not_to be_nil
    end
    context 'no available token' do
      let!(:other_test_execution_share) { create :test_execution_share, token: 'abc' }
      before do
        allow(SecureRandom).to receive(:hex).and_return other_test_execution_share.token
      end
      it 'raises an exception' do
        expect do
          subject.valid?
        end.to raise_error(RuntimeError, 'Can not assign a token')
      end
    end
    context 'update case' do
      it 'doesn not assign a token' do
        subject(:test_execution_share) { create :test_execution_share }
        token = subject.token
        subject.valid?
        expect(subject.token).to eq token
      end
    end
  end
end
