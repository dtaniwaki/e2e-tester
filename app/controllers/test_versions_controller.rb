class TestVersionsController < BaseController
  auto_decorate :test_versions, :test_version, only: [:index, :show]

  def index
    @test = Test.find(params[:test_id])
    authorize @test, :show?

    @test_versions = policy_scope(@test.test_versions).latest.page(params[:page]).per(20)
  end

  def show
    @test_version = Test.find(params[:test_id]).test_versions.includes(:test, test_browsers: :browser).find_by_position(params[:num])
    authorize @test_version
    @test = @test_version.test

    if current_user.user_tests.with_test(@test_version.test).exists?
      @test_executions = @test_version.test_executions.eager_load(:user).latest.limit(10)
    elsif current_user.user_test_versions.with_test_version(@test_version).exists?
      @test_executions = current_user.test_executions.with_test_version(@test_version).eager_load(:user).latest.limit(10)
    end
    if current_user.user_test_versions.with_test_version(@test_version).exists?
      @user_test_version = @test_version.user_test_versions.with_user(current_user).eager_load(:user_test_version_variables).first!
    end
    @user_test_versions = @test_version.user_test_versions.eager_load(:user).limit(10) if policy(@test_version.test).show?
  end

  def destroy
    @test_version = Test.find(params[:test_id]).test_versions.find_by_position(params[:num])
    authorize @test_version

    @test_version.destroy!

    flash[:alert] = 'Succesfully deleted the test_version'
    redirect_to test_test_versions_path(@test_version.test)
  end
end
