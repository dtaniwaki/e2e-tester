require 'rails_helper'

RSpec.describe DeviseHelper, type: :helper do
  describe '#devise_error_messages!' do
    let(:resource) { create :user }
    before do
      local_resource = resource
      helper.define_singleton_method :resource do
        local_resource
      end
    end
    it 'returns error messages' do
      expect(helper.devise_error_messages!).to eq ''
    end
    context 'with errors' do
      let(:message) { %(<div class="alert alert-error alert-danger">\n  <button type="button" class="close" data-dismiss="alert">×</button>\n  <li>foo</li>\n</div>\n) }
      it 'returns error messages' do
        resource.errors.add :base, 'foo'
        expect(helper.devise_error_messages!).to eq message
      end
    end
  end
end
