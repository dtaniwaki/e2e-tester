require 'rails_helper'

RSpec.describe TestStepSet, type: :model do
  subject { create :test }
  describe '#same_test_step_set?' do
    let(:browsers) { create_list(:browser, 1) }
    let(:base_test_step_set) { create :test }
    let(:test_steps_attributes) { [attributes_for(:test_step)] }
    let(:target_attributes) { [attributes_for(:test_step)] }
    subject { create :test, base_test_step_set: base_test_step_set, test_steps_attributes: test_steps_attributes, title: 'foo', description: 'foo', browsers: browsers }
    it 'returns true for a cloned instance' do
      expect(subject.same_test_step_set?(subject.clone)).to be true
    end
    context 'against the test step set' do
      let(:target) { create :shared_test_step_set, base_test_step_set: base_test_step_set, test_steps_attributes: target_attributes, title: 'foo', description: 'foo' }
      it 'returns false if the other instance is a shared test step set' do
        expect(subject.same_test_step_set?(target)).to be false
      end
    end
    context 'for other instance' do
      let(:target) { create :test, base_test_step_set: base_test_step_set, test_steps_attributes: target_attributes, title: 'foo', description: 'foo', browsers: browsers }
      before do
        expect(subject).not_to eq target
      end
      it 'returns true for the same contents' do
        expect(subject.same_test_step_set?(target)).to be true
      end
      context 'test_steps is different' do
        let(:target_attributes) { [attributes_for(:test_step), attributes_for(:test_step)] }
        it 'returns false' do
          expect(subject.same_test_step_set?(target)).to be false
        end
      end
    end
  end
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
