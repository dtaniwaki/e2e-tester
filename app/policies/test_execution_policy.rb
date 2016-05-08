class TestExecutionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.user == @user ||
      @record.test.user_tests.with_user(@user).exists?
  end

  def create?
    @record.test_version.user_test_versions.with_user(@user).exists? ||
      @record.test.user_tests.with_user(@user).exists?
  end

  def done?
    @record.user == @user ||
      @record.test.user_tests.with_user(@user).exists?
  end

  class Scope < Scope
    def resolve
      if @context && @user.user_tests.with_test(@context.test).exists?
        scope
      else
        scope.with_user(@user)
      end
    end
  end
end
