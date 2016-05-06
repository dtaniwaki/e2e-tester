class TestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.user_tests.with_user(@user).exists?
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    @record.user_tests.with_user(@user).exists?
  end

  def edit?
    update?
  end

  def destroy?
    @record.user_tests.with_user(@user).exists?
  end
end
