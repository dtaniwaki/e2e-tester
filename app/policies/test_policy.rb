class TestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.user_tests.with_user(@user).exists? ||
      (@record.project && @record.project.user_projects.with_user(@user).exists?)
  end

  def create?
    (@record.project && @record.project.user_projects.with_user(@user).exists?)
  end

  def update?
    (@record.project && @record.project.user_projects.with_user(@user).exists?)
  end

  def destroy?
    (@record.project && @record.project.user_projects.with_user(@user).exists?)
  end
end
