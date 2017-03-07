module CommonType
  DateTimeType = GraphQL::ScalarType.define do
    name 'DateTimeType'
    coerce_input ->(dt) { DateTime.zone.parse(dt) }
    coerce_result ->(dt) { dt.iso8601 }
  end
end
