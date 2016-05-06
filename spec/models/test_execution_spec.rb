require 'rails_helper'

RSpec.describe TestExecution, type: :model do
  describe 'after_commit :send_notification!' do
    shared_examples 'validate notification sending' do |from_state, to_state, flag|
      let(:test) { create :test }
      let(:test_version) { create :test_version, test: test }
      subject!(:test_execution) { create :test_execution, state: from_state, test_version: test_version, user: test.user }
      context "#{from_state} to #{to_state}" do
        it 'sends a notification to related users' do
          call_count = 0
          allow(UserMailer).to receive_message_chain(:test_execution_result, :deliver_now) do
            call_count += 1
            nil
          end
          subject.update_attributes! state: to_state
          expect(call_count).to eq flag ? 1 : 0
        end
        context 'with other test users' do
          let!(:user_test1) { create :user_test, test: test }
          let!(:user_test2) { create :user_test, test: test }
          it 'sends a notification to related users' do
            call_count = 0
            allow(UserMailer).to receive_message_chain(:test_execution_result, :deliver_now) do
              call_count += 1
              nil
            end
            subject.update_attributes! state: to_state
            expect(call_count).to eq flag ? 3 : 0
          end
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
end
