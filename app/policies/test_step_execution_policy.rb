class TestStepExecutionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.test_execution.user == @user ||
      @record.test_execution.project.user_projects.where(user_id: @user.id).exists?
  end
end
