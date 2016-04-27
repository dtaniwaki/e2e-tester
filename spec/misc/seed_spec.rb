require 'rails_helper'

RSpec.describe 'seed.rb' do # rubocop:disable RSpec/DescribeClass
  it 'succeeds' do
    expect(User.count).to be 0
    expect do
      load Rails.root.join('db', 'seeds.rb')
    end.not_to raise_error
    expect(User.count).to be > 0
  end
end
