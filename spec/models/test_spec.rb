require 'rails_helper'

RSpec.describe Test, type: :model do
  subject { create :test }
  describe '#same_test?' do
    let(:browsers) { create_list(:browser, 1) }
    let(:base_test) { create :test }
    subject { create :test, base_test: base_test, browsers: browsers }
    it 'returns true for a cloned instance' do
      expect(subject.same_test?(subject.clone)).to be true
    end
    context 'for other instance' do
      let(:target) { create :test, base_test: base_test, browsers: browsers }
      before do
        expect(subject).not_to eq target
      end
      it 'returns true for the same contents' do
        expect(subject.same_test?(target)).to be true
      end
      context 'test_id is different' do
        it 'returns false' do
          target.test_id = create(:test).id
          expect(subject.same_test?(target)).to be false
        end
      end
      context 'browser_ids is different' do
        it 'returns false' do
          target.browsers = create_list(:browser, 1)
          expect(subject.same_test?(target)).to be false
        end
      end
      context 'test_steps is different' do
        it 'returns false' do
          target.assign_attributes(test_steps_attributes: subject.test_steps_attributes + "\nNone")
          expect(subject.same_test?(target)).to be false
        end
      end
    end
  end
  describe 'validate :validate_same_test' do
    let(:step) { create :test_step, message: 'same' }
    let(:base_test) { create :test, test_steps: [step], browser_count: 2 }
    context 'against the base test with the same content' do
      subject { build :test, test_steps: [step], browsers: base_test.browsers, base_test: base_test }
      it 'fails and adds the error' do
        subject.save
        expect(subject).to be_invalid
        expect(subject.errors[:base]).to eq ['The test is the same as the base test']
      end
    end
    context 'against the base test with the different content' do
      let(:different_step) { create :test_step, message: 'different' }
      subject { build :test, test_steps: [different_step], browsers: base_test.browsers, base_test: base_test }
      it 'fails and adds the error' do
        subject.save
        expect(subject).to be_valid
      end
    end
  end
end
