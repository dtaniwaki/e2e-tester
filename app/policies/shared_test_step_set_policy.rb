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
      @record.user_test_step_set_shares.with_user(@user).exists?
  end
end
