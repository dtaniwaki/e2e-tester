require 'rails_helper'

RSpec.describe RenderHelper, type: :helper do
  describe '#markdown' do
    it 'returns the markdown' do
      expect(helper.markdown("# test\n## test")).to eq "<h1>test</h1>\n\n<h2>test</h2>\n"
    end
  end
end
