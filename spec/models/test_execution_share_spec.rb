require 'rails_helper'

RSpec.describe TestExecutionShare, type: :model do
  subject(:test_execution_share) { build :test_execution_share }
  describe 'before_validation :assign_token' do
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
  end
end
