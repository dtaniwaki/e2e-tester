require 'rails_helper'

RSpec.describe HashidsExt, type: :model do
  def save_without_transaction(params = {})
    s = subject.new(params)
    s.method(:save!).super_method.call
    s
  end

  table_name = "hashids_ext_specs_#{Time.now.to_i}_#{rand(999)}"

  around :context do |block|
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table table_name, force: true do |t|
      t.integer :parent_id, index: true
    end
    begin
      block.call
    ensure
      m.drop_table table_name
    end
  end

  subject do
    dynamic_name = "HashidsExtSpec_#{Time.now.to_i}_#{rand(999)}"
    Object.send :remove_const, dynamic_name if Object.const_defined?(dynamic_name)
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = table_name
      include HashidsExt # rubocop:disable RSpec/DescribedClass
      has_many :children, class_name: dynamic_name, foreign_key: :parent_id
    end
    Object.const_set dynamic_name, klass
    Object.const_get dynamic_name
  end

  before do
    allow(Settings.application.misc).to receive(:hashids_secret).and_return 'secret'
    allow(subject).to receive(:name).and_return 'foo'
  end

  describe '.find' do
    let!(:record1) { save_without_transaction }
    let!(:record2) { save_without_transaction }
    context 'for single argument' do
      it 'decodes hash id and returns the record' do
        expect(subject.find(record1.to_param)).to eq record1
      end
      context 'with invalid hash id' do
        it 'raises an exception' do
          expect { subject.find('@') }.to raise_error('Decode error')
        end
      end
      context 'with unexisting hash id' do
        it 'raises an exception' do
          expect { subject.find('B5Ma0gp5') }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find foo with 'id'=99999")
        end
      end
    end
    context 'for multiple arguments' do
      it 'decodes hash id and returns the record' do
        expect(subject.find([record1.to_param, record2.to_param])).to eq [record1, record2]
      end
      context 'with invalid hash id' do
        it 'raises an exception' do
          expect { subject.find(['@']) }.to raise_error('Decode error')
        end
      end
      context 'with unexisting hash id' do
        it 'raises an exception' do
          expect { subject.find(['B5Ma0gp5']) }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find foo with 'id'=[99999]")
        end
      end
    end
    context 'as ActiveRecord_Relation' do
      it 'decodes hash id and returns the record' do
        expect(subject.where(nil).find(record1.to_param)).to eq record1
      end
    end
    context 'as ActiveRecord_Associations_CollectionProxy' do
      let!(:record3) { save_without_transaction parent_id: record1.id }
      let!(:record4) { save_without_transaction parent_id: record1.id }
      it 'decodes hash id and returns the record' do
        expect(record1.children.find(record3.to_param)).to eq record3
      end
    end
  end
  describe '#to_param' do
    let!(:record) { save_without_transaction }
    it 'returns hash id' do
      allow(record).to receive(:id).and_return 5
      expect(record.to_param).to eq '6AZjnZ3W'
    end
  end
end
