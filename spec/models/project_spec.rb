require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { create :project }
  describe '#current_test=' do
    context 'current_test is nil' do
      subject { build :project }
      it 'assigns new test' do
        test = build :test, project: subject
        subject.current_test = test
        expect(subject.current_test).to be test
      end
    end
    context 'new test is different from the current' do
      before do
        allow(subject.current_test).to receive(:same_test?).and_return false
      end
      it 'doesn\'t assign new test' do
        test = subject.current_test
        new_test = build :test, project: subject
        subject.current_test = new_test
        expect(subject.current_test).to be new_test
        expect(subject.current_test).not_to be test
      end
    end
    context 'new test is the same as the current' do
      before do
        allow(subject.current_test).to receive(:same_test?).and_return true
      end
      it 'doesn\'t assign new test' do
        test = subject.current_test
        new_test = build :test, project: subject
        subject.current_test = new_test
        expect(subject.current_test).not_to be new_test
        expect(subject.current_test).to be test
      end
    end
  end
  describe '#update_test' do
    let(:user) { create :user }
    it 'sets an user in updating test' do
      test_params = attributes_for :test
      subject.update_test({current_test_attributes: test_params}, user)
      expect(subject.current_test.user).to eq user
    end
  end
  describe '#update_attributes' do
    subject { described_class.private_method_defined?(:update_attributes) }
    it { is_expected.to be true }
  end
end
