require 'rails_helper'

RSpec.describe UserTestVersion, type: :model do
  describe 'after_commit :send_notification!' do
    let!(:test_version) { create :test_version }
    subject { build :user_test_version, test_version: test_version, assigned_by: test_version.user }
    it 'sends a notification to the user' do
      expect(UserMailer).to receive_message_chain(:assigned_test_version, :deliver_now!).and_return nil
      subject.save!
    end
    context 'for non user assignment' do
      subject { build :user_test_version, test_version: test_version, assigned_by: nil }
      it 'does not send a notification' do
        expect(UserMailer).not_to receive(:assigned_test_version)
        subject.save!
      end
    end
  end
end
