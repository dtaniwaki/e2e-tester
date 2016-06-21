class TestVersionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.test.present? && (
      @record.user_test_versions.with_user(@user).exists? ||
      (@record.test && @record.test.user_tests.with_user(@user).exists?)
    )
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    @record.test.present? &&
      (@record.test && @record.test.user_tests.with_user(@user).exists?)
  end
end
