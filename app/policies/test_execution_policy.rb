class TestExecutionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.test.present? && @record.test_version.present? && (
      @record.with_authorized_token? ||
      @record.user == @user ||
      @record.test.user_tests.with_user(@user).exists?
    )
  end

  def create?
    @record.test.present? && @record.test_version.present? && (
      @record.test_version.user_test_versions.with_user(@user).exists? ||
      @record.test.user_tests.with_user(@user).exists?
    )
  end

  def done?
    @record.test.present? && @record.test_version.present? && (
      @record.user == @user ||
      @record.test.user_tests.with_user(@user).exists?
    )
  end

  class Scope < Scope
    def resolve
      if @context && @user.user_tests.with_test(@context.test).exists?
        scope.without_deleted
      else
        scope.with_user(@user).without_deleted
      end
    end
  end
end
