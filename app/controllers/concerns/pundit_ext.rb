module PunditExt
  def policy_scope(scope, context = nil)
    skip_policy_scope
    policy_scope = Pundit::PolicyFinder.new(scope).scope
    policy_scope.new(current_user, scope, context).resolve if policy_scope
  end

  def policy_scope!(scope, context = nil)
    skip_policy_scope
    Pundit::PolicyFinder.new(scope).scope!.new(current_user, scope, context).resolve
  end
end
