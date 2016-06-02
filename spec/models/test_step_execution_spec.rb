require 'rails_helper'

RSpec.describe TestStepExecution, type: :model do
  subject(:test_step_execution) { create :test_step_execution }
  describe '#execute!' do
    let(:variables) { {} }
    let(:driver) { double }
    let(:test_step) { test_step_execution.test_step }
    it 'executes test steps' do
      expect(test_step).to receive(:execute!).with(subject, driver, variables).once
      subject.execute!(driver, variables)
    end
  end
end
