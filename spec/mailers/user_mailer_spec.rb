require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create :user }
  describe '#assigned_test_version' do
    let(:test_version) { create :test_version }
    subject(:mail) { described_class.assigned_test_version(user, test_version).deliver_now }
    it 'sends an email' do
      expect(subject.subject).to eq 'Assigned test version'
      expect(subject.from).to eq ['foo@example.com']
      expect(subject.to).to eq [user.email]
      expect(subject.body.encoded).to match ''
    end
  end
  describe '#assigned_test' do
    let(:test) { create :test }
    subject(:mail) { described_class.assigned_test(user, test).deliver_now }
    it 'sends an email' do
      expect(subject.subject).to eq 'Assigned test'
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
