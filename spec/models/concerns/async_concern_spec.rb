require 'rails_helper'

RSpec.describe AsyncConcern, type: :model do
  subject do
    Class.new(ActiveRecord::Base) do
      include AsyncConcern

      def id
        1
      end

      def foo; end

      def foo!; end

      def self.name
        'Foo'
      end
    end
  end
  before do
    allow(subject).to receive_message_chain(:connection, :schema_cache, :columns_hash).and_return({})
    AsyncRecordJob.jobs.clear
  end
  describe '#method_missing' do
    it 'defines async method automatically and execute it' do
      expect(subject.instance_methods).not_to include(:foo_async)
      r = subject.new
      expect do
        r.foo_async
      end.not_to raise_error
      expect(subject.instance_methods).to include(:foo_async)
      expect(AsyncRecordJob.jobs).to contain_exactly(a_hash_including('class' => 'AsyncRecordJob',
                                                                      'args' => ['Foo', 1, 'foo']))
    end
    context 'with ! postfix' do
      it 'defines async method automatically and execute it' do
        expect(subject.instance_methods).not_to include(:foo_async!)
        r = subject.new
        expect do
          r.foo_async!
        end.not_to raise_error
        expect(subject.instance_methods).to include(:foo_async!)
        expect(AsyncRecordJob.jobs).to contain_exactly(a_hash_including('class' => 'AsyncRecordJob',
                                                                        'args' => ['Foo', 1, 'foo!']))
      end
    end
    context 'for undefined sync method' do
      it 'does not define async method nor execute it' do
        expect(subject.instance_methods).not_to include(:bar_async)
        r = subject.new
        expect do
          r.bar_async
        end.to raise_error(NoMethodError)
        expect(subject.instance_methods).not_to include(:bar_async)
        expect(AsyncRecordJob.jobs).to eq []
      end
    end
  end
  describe '#respond_to_missing?' do
    it 'defines async method automatically and execute it' do
      expect(subject.instance_methods).not_to include(:foo_async)
      r = subject.new
      expect(r).to respond_to(:foo_async)
    end
    context 'with ! postfix' do
      it 'defines async method automatically and execute it' do
        expect(subject.instance_methods).not_to include(:foo_async!)
        r = subject.new
        expect(r).to respond_to(:foo_async!)
      end
    end
    context 'for undefined sync method' do
      it 'does not define async method nor execute it' do
        expect(subject.instance_methods).not_to include(:bar_async)
        r = subject.new
        expect(r).not_to respond_to(:bar_async)
      end
    end
  end
end
