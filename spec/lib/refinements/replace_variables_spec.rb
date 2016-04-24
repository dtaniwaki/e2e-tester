require 'rails_helper'

RSpec.describe Refinements::ReplaceVariables do
  using described_class
  describe '#replace_variables' do
    it 'replace variables' do
      expect('{a}-{b}'.replace_variables(a: 1, b: 2)).to eq '1-2'
    end
  end
end
