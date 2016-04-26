class MiscController < BaseController
  skip_after_action :verify_authorized
  after_action :verify_policy_scoped

  def home
    @projects = policy_scope(current_user.accessible_projects).latest.limit(20)
    @tests = policy_scope(current_user.accessible_tests).latest.limit(20)
  end

  def tests
    @tests = policy_scope(current_user.accessible_tests).latest.page(params[:page]).per(20)
  end
end
