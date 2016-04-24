require 'rails_helper'

RSpec.describe Browser::Local, type: :model do
  describe '#name' do
    subject { create :local_browser, browser: 'foo', device: 'bar' }
    it 'returns the name' do
      expect(subject.name).to eq 'foo (bar)'
    end
    context 'with name' do
      subject { create :local_browser, browser: 'foo', device: 'bar', name: 'wow' }
      it 'returns the name' do
        expect(subject.name).to eq 'wow'
      end
    end
  end
  describe '#driver' do
    subject { create :local_browser, browser: :phantomjs }
    it 'returns the driver' do
      expect(subject.driver).to be_a Selenium::WebDriver::Driver
    end
  end
end
