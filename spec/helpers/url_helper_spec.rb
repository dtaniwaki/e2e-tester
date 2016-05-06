require 'rails_helper'

RSpec.describe UrlHelper, type: :helper do
  let(:test_version) { create :test_version }
  let(:test_step_set) { create :shared_test_step_set }
  let(:url_helpers) { Rails.application.routes.url_helpers }
  before do
    # Workaround of the UrlFor module issue
    #   https://github.com/rails/rails/pull/24679
    allow(helper).to receive(:test_version_position_path).and_return(url_helpers.test_test_version_path(test_version.test, test_version.position, options))
    allow(helper).to receive(:test_step_set_path).and_return(url_helpers.test_step_set_path(test_step_set, options))
  end
  let(:options) { {} }
  describe '#polymorphic_test_step_set_path' do
    context 'for test_version' do
      it 'returns test_version_position_path' do
        expect(helper.polymorphic_test_step_set_path(test_version, options)).to eq url_helpers.test_test_version_path(test_version.test, test_version.position, options)
      end
    end
    context 'for test_step_set' do
      it 'returns test_step_set_path' do
        expect(helper.polymorphic_test_step_set_path(test_step_set, options)).to eq url_helpers.test_step_set_path(test_step_set, options)
      end
    end
  end
end
