require 'rails_helper'

RSpec.describe TestStep::Base, type: :model do
  describe 'validate :validate_as_subclass' do
    subject(:test_step) { build :navigation_step, url: 'foo' }
    it 'is not valid' do
      expect(subject).not_to be_valid
      expect(subject.errors[:url]).to eq ['is invalid format']
    end
    context 'as superclass' do
      subject(:test_step) { build(:navigation_step, url: 'foo').becomes(described_class) }
      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:url]).to eq ['is invalid format']
      end
    end
  end
end
