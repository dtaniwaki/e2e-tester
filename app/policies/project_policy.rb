class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    @record.user_projects.with_user(@user).exists?
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    @record.user_projects.with_user(@user).exists?
  end

  def edit?
    update?
  end

  def destroy?
    @record.user_projects.with_user(@user).exists?
  end
end
