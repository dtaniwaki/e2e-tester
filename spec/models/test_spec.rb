require 'rails_helper'

RSpec.describe Test, type: :model do
  subject { create :test }
  describe '#same_test?' do
    let(:browsers) { create_list(:browser, 1) }
    let(:parent) { create :test }
    subject { create :test, parent: parent, browsers: browsers }
    it 'returns true for a cloned instance' do
      expect(subject.same_test?(subject.clone)).to be true
    end
    context 'for other instance' do
      let(:target) { create :test, parent: parent, browsers: browsers }
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
end
