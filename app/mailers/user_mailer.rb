class UserMailer < ApplicationMailer
  def assigned_test(user_test)
    @user = user_test.user
    @test = user_test.test
    mail to: @user.email
  end

  def assigned_project(user_project)
    @user = user_project.user
    @project = user_project.project
    mail to: @user.email
  end

  def task_execution_result(user_project)
    @user = user_test.user
    @project = user_project.project
    mail to: @user.email
  end
end
