Rails.application.config.to_prepare do
  ActiveRecord::Base.class_eval do
    def self.lazy_find(ctx, ids)
      if ids.is_a?(Array)
        ids.map { |id| LazyResolveActiveRecord.new(ctx, self, id) }
      else
        LazyResolveActiveRecord.new(ctx, self, ids)
      end
    end
  end

  Schema.define do
    lazy_resolve LazyResolveActiveRecord, :record
  end
end
