require 'rails_helper'

RSpec.describe TestStep::Eval, type: :model do
  describe '#execute!' do
    subject(:test_step) { create :eval_step, javascript: '"foo"' }
    let(:driver) do
      dbl = double
      allow(dbl).to receive(:execute_script) { |code| ExecJS.eval code }
      dbl
    end
    it 'executes javascript' do
      expect(driver).to receive(:execute_script).with(/^        \(function\(\) \{\n          try \{\n            \"foo\";\n          \} catch\(e\) \{\n            return 'e2e-[0-9a-f]+-' \+ e.message;\n          \}\n        \}\)\(\)\n$/) # rubocop:disable Metrics/LineLength
      expect(subject.execute!(nil, driver)).to be_nil
    end
    context 'JS throws an exception' do
      subject(:test_step) { create :eval_step, javascript: 'throw new Error("bar")' }
      it 'raises an exception' do
        expect do
          subject.execute!(nil, driver)
        end.to raise_error(E2eTester::JavaScriptError, 'bar')
      end
    end
    context 'with placeholder' do
      subject(:test_step) { create :eval_step, javascript: '"{foo}"' }
      it 'executes javascript' do
        expect(driver).to receive(:execute_script).with(/^        \(function\(\) \{\n          try \{\n            \"bar\";\n          \} catch\(e\) \{\n            return 'e2e-[0-9a-f]+-' \+ e.message;\n          \}\n        \}\)\(\)\n$/) # rubocop:disable Metrics/LineLength
        expect(subject.execute!(nil, driver, foo: 'bar')).to be_nil
      end
    end
  end
end
