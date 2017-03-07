class IndexOperationResolver
  def initialize(scope_block)
    @scope_block = scope_block
  end

  def call(obj, args, ctx)
    arel = @scope_block.call(obj, args, ctx)
    arel = arel.where(id: args[:ids]) unless args[:ids].nil?
    arel.page(args[:page]).per(args[:limit])
  end
end
