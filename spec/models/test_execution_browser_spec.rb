require 'rails_helper'

RSpec.describe TestExecutionBrowser, type: :model do
  let(:driver) { double quit: nil }
  let(:user) { create :user }
  let(:test_version) { create :test_version, test_steps: build_list(:test_step, 2) }
  let(:test_execution) { create :test_execution, test_version: test_version }
  subject(:test_execution_browser) { create :test_execution_browser, test_execution: test_execution }
  describe '#execute!' do
    let!(:user_variable) { create :user_variable, user: user, name: 'foo', value: 'bar' }
    before :example do
      subject.initialize_test_step_executions!
      allow(subject.browser).to receive(:driver).and_return(driver)
    end
    it 'executes test step executions' do
      expect(subject.test_step_executions.size).to eq 2
      expect(subject.test_step_executions[0]).to receive(:execute!).once.with(driver, foo: 'bar').and_return(nil)
      expect(subject.test_step_executions[1]).to receive(:execute!).once.with(driver, foo: 'bar').and_return(nil)
      subject.execute!(user)
    end
    context 'new variables' do
      it 'executes test step executions' do
        expect(subject.test_step_executions.size).to eq 2
        expect(subject.test_step_executions[0]).to receive(:execute!).once.with(driver, foo: 'bar') do |_driver, variables|
          variables[:foo] = 'wow'
          nil
        end
        expect(subject.test_step_executions[1]).to receive(:execute!).once.with(driver, foo: 'wow').and_return(nil)
        subject.execute!(user)
      end
    end
  end
end
