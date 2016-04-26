require 'rails_helper'

RSpec.describe BootstrapHelper, type: :helper do
  describe '#bootstrap_status_tag' do
    context 'with ok status' do
      it 'returns message with status icon' do
        expect(helper.bootstrap_status_tag(:span, 'foo', true, false)).to eq '<span class="text-success"><span class="glyphicon glyphicon-ok">foo</span></span>'
      end
    end
    context 'with ng status' do
      it 'returns message with status icon' do
        expect(helper.bootstrap_status_tag(:span, 'foo', false, true)).to eq '<span class="text-danger"><span class="glyphicon glyphicon-remove">foo</span></span>'
      end
    end
    context 'with ok and ng status' do
      it 'returns message with status icon' do
        expect(helper.bootstrap_status_tag(:span, 'foo', true, true)).to eq '<span class="text-success"><span class="glyphicon glyphicon-ok">foo</span></span>'
      end
    end
    context 'with non ok and non ng status' do
      it 'returns message with status icon' do
        expect(helper.bootstrap_status_tag(:span, 'foo', false, false)).to eq '<span>foo</span>'
      end
    end
    context 'default ng' do
      context 'with ok status' do
        it 'returns message with status icon' do
          expect(helper.bootstrap_status_tag(:span, 'foo', true)).to eq '<span class="text-success"><span class="glyphicon glyphicon-ok">foo</span></span>'
        end
      end
      context 'with non ok status' do
        it 'returns message with status icon' do
          expect(helper.bootstrap_status_tag(:span, 'foo', false)).to eq '<span class="text-danger"><span class="glyphicon glyphicon-remove">foo</span></span>'
        end
      end
    end
  end
end
