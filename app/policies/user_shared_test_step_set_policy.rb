class UserSharedTestStepSetPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    @record.shared_test_step_set.user == @user
  end

  def destroy?
    @record.shared_test_step_set.user == @user &&
      @record.user != @user
  end
end
