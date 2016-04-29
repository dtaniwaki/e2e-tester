class MiscController < BaseController
  skip_after_action :verify_authorized
  after_action :verify_policy_scoped

  auto_decorate :tests

  def home
    @projects = policy_scope(current_user.accessible_projects).latest.limit(20)
    @tests = policy_scope(current_user.accessible_tests).latest.limit(20)
  end

  def tests
    @tests = policy_scope(current_user.accessible_tests).latest.page(params[:page]).per(20)
  end

  def test_executions
    @test_executions = policy_scope(current_user.test_executions).latest.page(params[:page]).per(20)
  end
end
