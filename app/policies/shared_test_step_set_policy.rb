class SharedTestStepSetPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.user_shared_test_step_sets.with_user(@user).exists?
  end

  def create?
    true
  end

  def update?
    @record.user_shared_test_step_sets.with_user(@user).exists?
  end

  def destroy?
    @record.user_shared_test_step_sets.with_user(@user).exists?
  end
end
