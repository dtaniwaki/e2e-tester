class MiscController < BaseController
  skip_after_action :verify_authorized
  after_action :verify_policy_scoped

  auto_decorate :user_test_versions

  def home
    @tests = policy_scope(current_user.accessible_tests).latest.limit(20)
    @user_test_versions = policy_scope(current_user.user_test_versions).eager_load(:test_version).latest.limit(20)
  end

  def assigned_tests
    @user_test_versions = policy_scope(current_user.user_test_versions).eager_load(:test_version).latest.page(params[:page]).per(20)
  end

  def test_executions
    @test_executions = policy_scope(current_user.test_executions).latest.page(params[:page]).per(20)
  end
end
