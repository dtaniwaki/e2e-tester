class UserIntegrationsController < BaseController
  def index
    @integrations = policy_scope!(current_user.user_integrations).all
  end
end
