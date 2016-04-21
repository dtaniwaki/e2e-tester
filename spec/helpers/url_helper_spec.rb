require 'rails_helper'

RSpec.describe UrlHelper, type: :helper do
  let(:test) { create :test }
  let(:test_step_set) { create :shared_test_step_set }
  before do
    # Workaround of the UrlFor module issue
    #   https://github.com/rails/rails/pull/24679
    allow(helper).to receive(:test_path).and_return(Rails.application.routes.url_helpers.test_path(test, options))
    allow(helper).to receive(:test_step_set_path).and_return(Rails.application.routes.url_helpers.test_step_set_path(test_step_set, options))
  end
  let(:options) { {} }
  describe '#polymorphic_test_step_set_path' do
    context 'for test' do
      it 'returns test_path' do
        expect(helper.polymorphic_test_step_set_path(test, options)).to eq Rails.application.routes.url_helpers.test_path(test, options)
      end
    end
    context 'for test_step_set' do
      it 'returns test_step_set_path' do
        expect(helper.polymorphic_test_step_set_path(test_step_set, options)).to eq Rails.application.routes.url_helpers.test_step_set_path(test_step_set, options)
      end
    end
  end
end
