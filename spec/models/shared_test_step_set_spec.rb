require 'rails_helper'

RSpec.describe SharedTestStepSet, type: :model do
  subject(:shared_test_step_set) { create :shared_test_step_set }
  describe 'after_create :assign_owner!' do
    subject(:shared_test_step_set) { build :shared_test_step_set }
    it 'assigns user_shared_test_step_set for the owner' do
      expect(subject.user_shared_test_step_sets.map(&:user)).to eq []
      subject.save!
      expect(subject.user_shared_test_step_sets.map(&:user)).to eq [subject.user]
    end
  end
end
