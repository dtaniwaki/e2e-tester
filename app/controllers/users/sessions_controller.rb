module Users
  class SessionsController < Devise::SessionsController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped
  end
end
