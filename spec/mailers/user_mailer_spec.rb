require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create :user }
  describe '#assigned_test' do
    let(:user_test) { create :user_test, user: user }
    subject(:mail) { described_class.assigned_test(user_test).deliver_now }
    it 'sends an email' do
      expect(subject.subject).to eq 'Assigned test'
      expect(subject.from).to eq ['foo@example.com']
      expect(subject.to).to eq [user.email]
      expect(subject.body.encoded).to match ''
    end
  end
  describe '#assigned_project' do
    let(:user_project) { create :user_project, user: user }
    subject(:mail) { described_class.assigned_project(user_project).deliver_now }
    it 'sends an email' do
      expect(subject.subject).to eq 'Assigned project'
      expect(subject.from).to eq ['foo@example.com']
      expect(subject.to).to eq [user.email]
      expect(subject.body.encoded).to match user.name
    end
  end
  describe '#test_execution_result' do
    let(:test_execution) { create :test_execution }
    subject(:mail) { described_class.test_execution_result(user, test_execution).deliver_now }
    it 'sends an email' do
      expect(subject.subject).to eq 'Test execution result'
      expect(subject.from).to eq ['foo@example.com']
      expect(subject.to).to eq [user.email]
      expect(subject.body.encoded).to match user.name
    end
  end
end
