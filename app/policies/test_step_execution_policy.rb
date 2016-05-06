class TestStepExecutionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.test_execution.user == @user ||
      @record.test_execution.test.user_tests.with_user(@user).exists?
  end
end
