require 'rails_helper'

RSpec.describe UserTest, type: :model do
  describe 'after_commit :send_notification!' do
    let!(:test) { create :test }
    subject { build :user_test, test: test, assigned_by: test.user }
    it 'sends a notification to the user' do
      expect(UserMailer).to receive_message_chain(:assigned_test, :deliver_now!).and_return nil
      subject.save!
    end
    context 'for non user assignment' do
      subject { build :user_test, test: test, assigned_by: nil }
      it 'does not send a notification to the user' do
        expect(UserMailer).not_to receive(:assigned_test)
        subject.save!
      end
    end
  end
end
