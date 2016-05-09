class UserTestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.user == @user
  end

  def create?
    @record.test.user_tests.with_user(@user).exists?
  end

  def update?
    @record.user == @user
  end
end
