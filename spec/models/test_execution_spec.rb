require 'rails_helper'

RSpec.describe TestExecution, type: :model do
  describe 'after_commit :send_notification_async!' do
    shared_examples 'validate notification sending' do |from_state, to_state, flag|
      let(:test) { create :test }
      let(:test_version) { create :test_version, test: test }
      subject!(:test_execution) { create :test_execution, state: from_state, test_version: test_version, user: test.user }
      context "from #{from_state} to #{to_state}" do
        it 'sends a notification to related users' do
          if flag
            expect(subject).to receive(:send_notification_async!).once
          else
            expect(subject).to receive(:send_notification_async!).never
          end
          subject.update_attributes! state: to_state
        end
      end
    end
    {
      [:initial, :initial] => false,
      [:initial, :running] => false,
      [:initial, :failed] => true,
      [:initial, :done] => true,
      [:running, :initial] => false,
      [:running, :running] => false,
      [:running, :failed] => true,
      [:running, :done] => true,
      [:failed, :initial] => false,
      [:failed, :running] => false,
      [:failed, :failed] => false,
      [:failed, :done] => true,
      [:done, :initial] => false,
      [:done, :running] => false,
      [:done, :failed] => true,
      [:done, :done] => false
    }.each do |(from_state, to_state), flag|
      it_behaves_like 'validate notification sending', from_state, to_state, flag
    end
  end
  describe '#send_notification!' do
    let(:test) { create :test }
    let(:test_version) { create :test_version, test: test }
    let(:executer) { create :user }
    let(:owner) { test.user }
    subject!(:test_execution) { create :test_execution, test_version: test_version, user: executer }
    let(:sent_users) { [] }
    before do
      allow(UserMailer).to receive(:test_execution_result) do |user, _test_execution|
        sent_users << user
        double deliver_now: nil
      end
    end
    it 'sends email to the owner' do
      subject.send_notification!
      expect(sent_users).to match_array [owner, executer]
    end
    context 'with test users' do
      let!(:user_test1) { create :user_test, test: test }
      let!(:user_test2) { create :user_test, test: test }
      let(:user1) { user_test1.user }
      let(:user2) { user_test2.user }
      it 'sends email notifications to the owner and the stakehorlders' do
        subject.send_notification!
        expect(sent_users).to match_array [owner, executer, user1, user2]
      end
      context 'test users includes executer' do
        let(:executer) { user_test1.user }
        it 'sends email notifications to the stakehorlders' do
          subject.send_notification!
          expect(sent_users).to match_array [owner, executer, user2]
        end
      end
      context 'with integrations' do
        let!(:slack_integration1) { create :slack_integration, user: user_test1.user, webhook_url: 'http://www.example.com/' }
        it 'sends email and integration notifications to the stakehorlders' do
          stub = stub_request(:post, 'www.example.com')
          subject.send_notification!
          expect(stub).to have_been_made.once
          expect(sent_users).to match_array [owner, executer, user1, user2]
        end
      end
      context 'test_execution_result is never' do
        let!(:executer_setting) { create :user_notification_setting, user: executer, test: nil, user_integration: nil, notify_test_execution_result: 'never' }
        it 'doesn\'t send email notifications' do
          subject.send_notification!
          expect(sent_users).to match_array [owner, user1, user2]
        end
      end
      context 'test_execution_result is only_self' do
        let!(:executer_setting) { create :user_notification_setting, user: executer, test: nil, user_integration: nil, notify_test_execution_result: 'only_self' }
        let!(:test_setting) { create :user_notification_setting, user: user1, test: nil, user_integration: nil, notify_test_execution_result: 'only_self' }
        it 'doesn\'t send email notifications' do
          subject.send_notification!
          expect(sent_users).to match_array [owner, executer, user2]
        end
      end
    end
  end
  describe '#with_authorized_token?' do
    subject(:test_execution) { create :test_execution }
    let!(:share) { create :test_execution_share, test_execution: subject }
    context 'with token' do
      it 'returns true' do
        subject.token = share.token
        expect(subject.with_authorized_token?).to eq true
      end
      context 'with invalid token' do
        it 'returns false' do
          subject.token = share.token + '-invalid'
          expect(subject.with_authorized_token?).to eq false
        end
      end
    end
    context 'without token' do
      it 'returns false' do
        expect(subject.with_authorized_token?).to eq false
      end
    end
  end
end
