class MiscController < BaseController
  after_action :verify_authorized, except: :tests

  def tests
    @tests = policy_scope(current_user.accessible_tests).latest.page(params[:page]).per(20)
  end
end
