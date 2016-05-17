class SimilarRecordValidator < ::ActiveModel::Validator
  def validate(record)
    conditions = [options[:conditions] || []].flatten
    count = options[:count] || 1
    message = options[:message] || I18n.t(:too_many_similar_records, default: 'Too many similar records')

    arel = record.class
    arel = arel.where('id != ?', record.id) if !record.id.nil?
    fixed_conditions = conditions.last.is_a?(::Hash) ? conditions.pop : {}
    conditions.each do |cond|
      arel = arel.where(cond => record.send(cond))
    end
    fixed_conditions.each do |key, val|
      arel = arel.where(key => val)
    end

    if count == 1
      ok = !arel.exists?
    else
      ok = arel.count < count
    end

    unless ok
      record.errors.add(:base, message)
    end
  end
end
