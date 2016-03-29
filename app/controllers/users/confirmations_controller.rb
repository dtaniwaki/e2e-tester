module Users
  class ConfirmationsController < Devise::ConfirmationsController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped
  end
end
