module AsyncConcern
  def method_missing(method_name, *args, &block)
    if define_sync_method(method_name, *args, &block)
      public_send(method_name)
    else
      super(method_name, *args, &block)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    respond_to_sync_method?(method_name, include_private) || super
  end

  private

  def respond_to_sync_method?(method_name, include_private)
    return false if method_name.to_s !~ /_async!?$/

    real_method_name = method_name.to_s.sub(/_async(!)?$/, '\1')
    respond_to?(real_method_name, include_private)
  end

  def define_sync_method(method_name, *_args, &_block)
    return if method_name.to_s !~ /_async!?$/

    real_method_name = method_name.to_s.sub(/_async(!)?$/, '\1')
    return unless respond_to?(real_method_name)
    self.class.class_eval do
      define_method method_name do
        AsyncRecordJob.perform_async(self.class.name, id, real_method_name.to_sym)
      end
    end
    true
  end
end
