class UserCredentialsController < BaseController
  skip_after_action :verify_policy_scoped

  def index
    @browserstack_credential = current_user.browserstack_credential || current_user.build_browserstack_credential
  end
end
