class UserMailer < ApplicationMailer
  def assigned_test(user, test)
    @user = user
    @test = test
    mail to: @user.email
  end

  def assigned_project(user, project)
    @user = user
    @project = project
    mail to: @user.email
  end

  def test_execution_result(user, test_execution)
    @user = user
    @test_execution = test_execution
    @test = test_execution.test
    mail to: @user.email
  end
end
