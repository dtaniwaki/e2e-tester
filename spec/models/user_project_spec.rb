require 'rails_helper'

RSpec.describe UserProject, type: :model do
  describe 'after_commit :send_notification!' do
    let!(:project) { create :project }
    subject { build :user_project, project: project, assigned_by: project.user }
    it 'sends a notification to the user' do
      expect(UserMailer).to receive_message_chain(:assigned_project, :deliver_now!).and_return nil
      subject.save!
    end
    context 'for non user assignment' do
      subject { build :user_project, project: project, assigned_by: nil }
      it 'does not send a notification to the user' do
        expect(UserMailer).not_to receive(:assigned_project)
        subject.save!
      end
    end
  end
end
