require 'rails_helper'

RSpec.describe TestStep::Navigation, type: :model do
  describe 'validate :validate_as_subclass' do
    subject(:test_step) { build :navigation_step, url: 'http://example.com/' }
    it 'is not valid' do
      expect(subject).to be_valid
    end
    context 'with only placeholder' do
      subject(:test_step) { build :navigation_step, url: '{foo}' }
      it 'is not valid' do
        expect(subject).to be_valid
      end
    end
    context 'with invalid URL' do
      subject(:test_step) { build :navigation_step, url: 'foo' }
      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:url]).to eq ['is invalid format']
      end
    end
  end
end
