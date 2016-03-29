class TestExecutionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.test.user_tests.with_user(@user).exists? ||
      @record.project.user_projects.with_user(@user).exists?
  end

  def create?
    @record.test.user_tests.with_user(@user).exists? ||
      @record.project.user_projects.with_user(@user).exists?
  end

  def done?
    @record.user == @user
  end
end
