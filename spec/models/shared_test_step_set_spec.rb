require 'rails_helper'

RSpec.describe SharedTestStepSet, type: :model do
  subject(:shared_test_step_set) { create :shared_test_step_set }
  describe 'after_create :assign_owner!' do
    subject(:project) { build :project }
    it 'assigns user_project for the owner' do
      expect(subject.user_projects.map(&:user)).to eq []
      subject.save!
      expect(subject.user_projects.map(&:user)).to eq [subject.user]
    end
  end
end
