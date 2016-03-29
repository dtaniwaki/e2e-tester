class UserProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    @record.project.user_projects.with_user(@user).exists?
  end

  def update?
    @record.user == @user
  end
end
