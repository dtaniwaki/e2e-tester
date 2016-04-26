require 'rails_helper'

RSpec.describe Test, type: :model do
  subject(:test) { create :test }
  describe '#same_test_step_set?' do
    let(:browsers) { create_list(:browser, 1) }
    let(:base_test_step_set) { create :test }
    subject { create :test, base_test_step_set: base_test_step_set, browsers: browsers }
    context 'for other instance' do
      let(:target) { create :test, base_test_step_set: base_test_step_set, browsers: browsers }
      before do
        expect(subject).not_to eq target
      end
      context 'browser_ids is different' do
        it 'returns false' do
          target.browsers = create_list(:browser, 1)
          expect(subject.same_test_step_set?(target)).to be false
        end
      end
    end
  end
end
