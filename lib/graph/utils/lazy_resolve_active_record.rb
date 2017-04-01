class LazyResolveActiveRecord
  def initialize(query_ctx, model, id)
    @query_ctx = query_ctx
    @model = model
    @id = id
    # Initialize the loading state for this query,
    # or get the previously-initiated state
    @lazy_state = query_ctx[:lazy_find] ||= {
      pending_ids: {},
      loaded_ids: {},
    }
    @lazy_state[:loaded_ids][@model] ||= {}
    @lazy_state[:pending_ids][@model] ||= Set.new
    # Register this ID to be loaded later:
    @lazy_state[:pending_ids][@model] << id
  end

  # Return the loaded record, hitting the database if needed
  def record
    # Check if the record was already loaded:
    loaded_record = @lazy_state[:loaded_ids][@model][@id]
    if loaded_record.nil?
      # The record hasn't been loaded yet, so
      # hit the database with all pending IDs
      pending_ids = @lazy_state[:pending_ids][@model].to_a
      records = @model.where(id: pending_ids)
      records.each { |record| @lazy_state[:loaded_ids][@model][record.id] = record }
      @lazy_state[:pending_ids][@model].clear
      # Now, get the matching person from the loaded result:
      loaded_record = @lazy_state[:loaded_ids][@model][@id]
    end

    # Check the accessibility
    Pundit.authorize(@query_ctx[:current_user], loaded_record, :show?)

    loaded_record
  end

  def self.set_records(ctx, records)  
    ctx[:loaded_ids] ||= {}
    records.each do |r|
      ctx[:loaded_ids][r.id] = r
    end
  end
end
