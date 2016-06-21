class TestStepExecutionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.test_execution.test.present? && @record.test_execution.test_version.present? && (
      @record.test_execution.with_authorized_token? ||
      @record.test_execution.user == @user ||
      @record.test_execution.test.user_tests.with_user(@user).exists?
    )
  end
end
