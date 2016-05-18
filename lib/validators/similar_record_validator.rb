class SimilarRecordValidator < ::ActiveModel::Validator
  def validate(record)
    conditions = [options[:conditions] || []].flatten
    count = options[:count] || 1
    message = options[:message] || I18n.t(:too_many_similar_records, default: 'Too many similar records')

    arel = record.class
    arel = arel.where('id != ?', record.id) unless record.id.nil?
    fixed_conditions = conditions.last.is_a?(::Hash) ? conditions.pop : {}
    conditions.each do |cond|
      arel = arel.where(cond => record.send(cond))
    end
    fixed_conditions.each do |key, val|
      arel = arel.where(key => val)
    end

    ok = if count == 1
      !arel.exists?
    else
      arel.count < count
    end

    record.errors.add(:base, message) unless ok
  end
end
