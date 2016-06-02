class UserNotificationSettingPolicy < ApplicationPolicy
  def create?
    @record.user == @user
  end

  def update?
    @record.user == @user
  end
end
