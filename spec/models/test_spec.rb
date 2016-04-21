require 'rails_helper'

RSpec.describe Test, type: :model do
  subject(:test) { create :test }
  describe '#title' do
    let(:project) { create :project, title: 'foo' }
    subject(:test) { create :test, project: project, title: 'bar' }
    it 'returns the title' do
      expect(subject.title).to eq 'bar'
    end
    context 'with empty title' do
      subject(:test) { create :test, project: project, title: nil }
      it 'returns project\'s title' do
        expect(subject.title).to eq 'foo'
      end
    end
  end
  describe '#same_test_step_set?' do
    let(:browsers) { create_list(:browser, 1) }
    let(:base_test_step_set) { create :test }
    subject { create :test, base_test_step_set: base_test_step_set, browsers: browsers }
    it 'returns true for a cloned instance' do
      expect(subject.same_test_step_set?(subject.clone)).to be true
    end
    context 'against the test step set' do
      let(:target) { create :shared_test_step_set, base_test_step_set: base_test_step_set }
      it 'returns false if the other instance is a shared test step set' do
        expect(subject.same_test_step_set?(target)).to be false
      end
    end
    context 'for other instance' do
      let(:target) { create :test, base_test_step_set: base_test_step_set, browsers: browsers }
      before do
        expect(subject).not_to eq target
      end
      it 'returns true for the same contents' do
        expect(subject.same_test_step_set?(target)).to be true
      end
      context 'test_step_set_id is different' do
        it 'returns false' do
          target.test_step_set_id = create(:test).id
          expect(subject.same_test_step_set?(target)).to be false
        end
      end
      context 'browser_ids is different' do
        it 'returns false' do
          target.browsers = create_list(:browser, 1)
          expect(subject.same_test_step_set?(target)).to be false
        end
      end
      context 'test_steps is different' do
        it 'returns false' do
          target.assign_attributes(test_steps_attributes: subject.test_steps_attributes + "\nNone")
          expect(subject.same_test_step_set?(target)).to be false
        end
      end
    end
  end
end
