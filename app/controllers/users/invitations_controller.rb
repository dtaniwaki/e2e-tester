module Users
  class InvitationsController < Devise::InvitationsController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped
  end
end
