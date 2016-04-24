require 'rails_helper'

RSpec.describe TestExecutionJob, type: :job do
  describe '#perform' do
    let!(:user) { create :user }
    let!(:test_execution) { create :test_execution, user: user }
    let!(:test_execution_browser) { create :test_execution_browser, test_execution: test_execution }
    it 'perform test execution' do
      expect_any_instance_of(TestExecutionBrowser).to receive(:execute!).with(user) do |teb|
        expect(teb).to eq test_execution_browser
        nil
      end
      described_class.new.perform(user.id, test_execution_browser.id)
    end
  end
end
