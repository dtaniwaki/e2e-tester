require 'rails_helper'

RSpec.describe AsyncRecordJob, type: :job do
  describe '#perform' do
    let!(:user) { create :user, name: rand(12).to_s }
    it 'perform test execution' do
      expect(described_class.new.perform('User', user.id, :name)).to eq user.name
    end
  end
end
