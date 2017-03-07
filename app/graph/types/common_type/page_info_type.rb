module CommonType
  PageInfoType = GraphQL::ObjectType.define do
    name 'PageInfoType'
    description 'Page information'

    field :totalCount, !types.Int, property: :total_count
    field :totalPages, !types.Int, property: :total_pages
    field :nextPage, types.Int, resolve: ->(scope, *_args) { scope.next_page unless scope.out_of_range? }
    field :previousPage, types.Int, resolve: ->(scope, *_args) { scope.prev_page unless scope.out_of_range? }
    field :hasNextPage, !types.Boolean, resolve: ->(scope, *_args) { !scope.out_of_range? && !scope.last_page? }
    field :hasPreviousPage, !types.Boolean, resolve: ->(scope, *_args) { !scope.out_of_range? && !scope.first_page? }
    field :isOutOfRange, !types.Boolean, property: :out_of_range?
  end
end
