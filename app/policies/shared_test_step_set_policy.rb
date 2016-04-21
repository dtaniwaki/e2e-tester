class SharedTestStepSetPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def destroy?
    @record.user == @user ||
      @record.user_shared_test_step_sets.with_user(@user).exists?
  end
end
