require 'rails_helper'

RSpec.describe Browser::Browserstack, type: :model do
  describe '#name' do
    subject { create :browserstack_browser, browser: 'foo', device: 'bar' }
    it 'returns the name' do
      expect(subject.name).to eq 'bar'
    end
    context 'with name' do
      subject { create :browserstack_browser, browser: 'foo', device: 'bar', name: 'wow' }
      it 'returns the name' do
        expect(subject.name).to eq 'wow'
      end
    end
  end
  describe '#driver', :vcr do
    subject { create :browserstack_browser, os: 'windows', os_version: '8', browser: 'firefox', browser_version: '32' }
    it 'returns the driver' do
      expect(subject.driver).to be_a Selenium::WebDriver::Driver
    end
  end
end
