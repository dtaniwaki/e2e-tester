require 'rails_helper'

RSpec.describe TestStep::StepSet, type: :model do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:shared_test_step_set) { create :shared_test_step_set }
  let!(:user_shared_test_step_set) { create :user_shared_test_step_set, user: another_user, shared_test_step_set: shared_test_step_set }
  let(:base_test_version) { create :test_version }
  let(:test_version) { create :test_version, user: user, base_test_step_set: base_test_version }
  subject(:test_step) { build :step_set_step, test_step_set: test_version, shared_test_step_set: shared_test_step_set }
  describe 'validate :validate_accessibility' do
    context 'for unaccessible user' do
      it 'fails' do
        expect(subject).not_to be_valid
      end
      context 'for copied test' do
        let(:base_test_version) { create :test_version, user: another_user, test_steps: build_list(:step_set_step, 1, shared_test_step_set: shared_test_step_set) }
        it 'succeeds' do
          expect(subject).to be_valid
        end
      end
    end
    context 'for accessible user' do
      let!(:user_shared_test_step_set) { create :user_shared_test_step_set, user: user, shared_test_step_set: shared_test_step_set }
      it 'succeeds' do
        expect(subject).to be_valid
      end
    end
  end
end
