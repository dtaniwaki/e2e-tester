class UserTestVersionPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    @record.test.present? &&
      @record.test_version.present? &&
      @record.test.user_tests.with_user(@user).exists?
  end

  def update?
    @record.test.present? &&
      @record.test_version.present? &&
      @record.user == @user
  end

  def destroy?
    @record.test.present? &&
      @record.test_version.present? &&
      @record.test.user_tests.with_user(@user).exists? &&
      @record.user != @user
  end
end
