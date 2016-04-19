require 'rails_helper'

RSpec.describe TestStepSet, type: :model do
  subject { create :test }
  describe 'validate :validate_same_test_step_set' do
    let(:base_test_step_set) { create :test }
    context 'against the base test with the same content' do
      subject { build :test, base_test_step_set: base_test_step_set }
      before do
        allow(subject).to receive(:same_test_step_set?).and_return true
      end
      it 'fails and adds the error' do
        subject.save
        expect(subject).to be_invalid
        expect(subject.errors[:base]).to eq ['The test is the same as the base test']
      end
    end
    context 'against the base test with the different content' do
      let(:different_step) { create :test_step, message: 'different' }
      subject { build :test, base_test_step_set: base_test_step_set }
      before do
        allow(subject).to receive(:same_test_step_set?).and_return false
      end
      it 'fails and adds the error' do
        subject.save
        expect(subject).to be_valid
      end
    end
  end
end
