class UserMailer < ApplicationMailer
  def assigned_test_version(user, test_version)
    @user = user
    @test_version = test_version
    mail to: @user.email
  end

  def assigned_test(user, test)
    @user = user
    @test = test
    mail to: @user.email
  end

  def test_execution_result(user, test_execution)
    @user = user
    @test_execution = test_execution
    @test = test_execution.test
    mail to: @user.email
  end
end
