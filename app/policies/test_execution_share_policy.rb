class TestExecutionSharePolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    @record.test_execution.test.present? &&
      @record.test_execution.test_version.present? &&
      @record.test_execution.user == @user
  end

  def update?
    @record.test_execution.test.present? &&
      @record.test_execution.test_version.present? &&
      @record.test_execution.user == @user
  end

  def destroy?
    @record.test_execution.test.present? &&
      @record.test_execution.test_version.present? &&
      @record.test_execution.user == @user
  end
end
