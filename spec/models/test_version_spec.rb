require 'rails_helper'

RSpec.describe TestVersion, type: :model do
  subject(:test_version) { create :test_version }
  describe '#same_test_step_set?' do
    let(:browsers) { create_list(:browser, 1) }
    let(:base_test_step_set) { create :test_version }
    subject { create :test_version, base_test_step_set: base_test_step_set, browsers: browsers }
    context 'for other instance' do
      let(:target) { create :test_version, base_test_step_set: base_test_step_set, browsers: browsers }
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
