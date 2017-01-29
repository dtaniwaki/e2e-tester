class TestExecutionsController < BaseController
  auto_decorate :test_version, :test_execution_shares, only: [:index, :show]
  skip_before_action :authenticate_user!, only: [:show]

  def index
    @test_version = Test.find(params[:test_id]).test_versions.find_by!(position: params[:number])
    authorize @test_version, :show?

    @test_executions = policy_scope(@test_version.test_executions, @test_version).eager_load(:user).latest.page(params[:page]).per(20)
  end

  def show
    @test_execution = TestExecution.includes(test_execution_browsers: [:browser, :test_step_executions], test_version: [:test, :test_steps]).find(params[:id])
    token = params[:token]
    if token
      @test_execution.token = token
    else
      authenticate_user!
    end
    authorize @test_execution

    @test_version = @test_execution.test_version
    @test_execution_shares = @test_execution.test_execution_shares.latest.available.limit(5)
  end

  def create
    @test_version = Test.find(params[:test_id]).test_versions.find_by!(position: params[:number])
    authorize @test_version, :show?
    @test_execution = @test_version.test_executions.with_user(current_user).build
    authorize @test_execution
    if @test_execution.save
      @test_execution.execute_async!(current_user)
      flash[:notice] = t('shared.execute_success', target: TestVersion.model_name.human)
      redirect_to test_execution_path(@test_execution)
    else
      flash[:alert] = t('shared.execute_failure', target: TestVersion.model_name.human, errors: @test_execution.errors.full_messages.join(', '))
      redirect_to :back
    end
  end

  def done
    @test_execution = TestExecution.includes(test_execution_browsers: { test_step_executions: :test_step }).find(params[:id])
    authorize @test_execution

    @test_execution_browsers = @test_execution.test_execution_browsers
  end
end
