class TestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tests = policy_scope(current_user.accessible_tests).latest.page(params[:page]).per(20)
  end

  def show
    @test = Test.includes(:project, test_browsers: :browser).find(params[:id])
    authorize @test

    if current_user.user_projects.with_project(@test.project).exists?
      @test_executions = @test.test_executions.eager_load(:user).latest.limit(10)
    elsif current_user.user_tests.with_test(@test).exists?
      @test_executions = current_user.test_executions.with_test(@test).eager_load(:user).latest.limit(10)
      @user_test = @test.user_tests.with_user(current_user).eager_load(:user_test_variables).first!
    end
    @is_owner = current_user.user_projects.with_project(@test.project).exists?
    @user_tests = @test.user_tests.eager_load(:user).limit(10) if @is_owner
  end

  def all_executions
    @test = Test.includes(:project, test_browsers: :browser).find(params[:id])
    authorize @test
    @test_executions = policy_scope(@test.test_executions).eager_load(:user).latest.page(params[:page]).per(20)
  end
end
