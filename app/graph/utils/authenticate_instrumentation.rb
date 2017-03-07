module AuthenticateInstrumentation
  module_function

  def before_query(query)
    operation = query.selected_operation
    context = query.context
    return if operation.name == 'IntrospectionQuery'
    return if context[:current_user].present?
    raise E2eTester::NotAuthenticated
  end

  def after_query(query)
    # NOOP
  end
end
