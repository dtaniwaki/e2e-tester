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
  describe '#driver', vcr: { cassette_name: 'Browser_Browserstack/_driver' } do
    subject { create :browserstack_browser, os: 'windows', os_version: '8', browser: 'firefox', device: 'wow', browser_version: '32' }
    context 'with global settings' do
      before do
        allow(Settings.browserstack).to receive(:username).and_return 'default_user'
        allow(Settings.browserstack).to receive(:password).and_return 'default_password'
        allow(Settings.application.misc).to receive(:use_global_browserstack_credential).and_return true
      end
      it 'returns the driver' do
        expect(Selenium::WebDriver).to receive(:for).with(:remote, hash_including(url: 'http://default_user:default_password@hub.browserstack.com/wd/hub')).and_call_original
        expect(subject.driver(nil)).to be_a Selenium::WebDriver::Driver
      end
      context 'with credential' do
        let(:credential) { create :browserstack_credential, username: 'foo', password: 'bar' }
        it 'returns the driver with the credential' do
          expect(Selenium::WebDriver).to receive(:for).with(:remote, hash_including(url: 'http://foo:bar@hub.browserstack.com/wd/hub')).and_call_original
          expect(subject.driver(credential)).to be_a Selenium::WebDriver::Driver
        end
      end
    end
    context 'without global settings' do
      before do
        allow(Settings.application.misc).to receive(:use_global_browserstack_credential).and_return false
      end
      it 'raises an exception' do
        expect do
          subject.driver(nil)
        end.to raise_error(RuntimeError)
      end
      context 'with credential' do
        let(:credential) { create :browserstack_credential, username: 'foo', password: 'bar' }
        it 'returns the driver with the credential' do
          expect(Selenium::WebDriver).to receive(:for).with(:remote, hash_including(url: 'http://foo:bar@hub.browserstack.com/wd/hub')).and_call_original
          expect(subject.driver(credential)).to be_a Selenium::WebDriver::Driver
        end
      end
    end
  end
end
