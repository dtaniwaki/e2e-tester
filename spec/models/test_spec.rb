require 'rails_helper'

RSpec.describe Test, type: :model do
  subject(:test) { create :test }
  describe 'after_create :assign_owner!' do
    subject(:test) { build :test }
    it 'assigns user_test for the owner' do
      expect(subject.user_tests.map(&:user)).to eq []
      subject.save!
      expect(subject.user_tests.map(&:user)).to eq [subject.user]
    end
  end
end
