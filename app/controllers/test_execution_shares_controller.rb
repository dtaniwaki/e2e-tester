class TestExecutionSharesController < BaseController
  auto_decorate :test_execution_shares, only: [:index]

  def index
    @test_execution = TestExecution.find(params[:test_execution_id])
    authorize @test_execution, :show?

    @test_execution_shares = policy_scope(@test_execution.test_execution_shares).latest.page(params[:page]).per(20)
  end

  def create
    @test_execution = TestExecution.find(params[:test_execution_id])
    authorize @test_execution, :show?

    @test_execution_share = @test_execution.test_execution_shares.build
    @test_execution_share.user = current_user
    authorize @test_execution_share

    @test_execution_share.assign_attributes(permitted_params)

    if @test_execution_share.save
      flash[:notice] = t('shared.create_success', target: TestExecutionShare.model_name.human)
    else
      flash[:alert] = t('shared.create_failure', target: TestExecutionShare.model_name.human, errors: @test_execution_share.errors.full_messages.join(', '))
    end
    redirect_to test_execution_path(@test_execution)
  end

  def update
    @test_execution_share = TestExecutionShare.find(params[:id])
    authorize @test_execution_share

    @test_execution_share.assign_attributes(permitted_params)

    if @test_execution_share.save
      flash[:notice] = t('shared.update_success', target: TestExecutionShare.model_name.human)
    else
      flash[:alert] = t('shared.update_failure', target: TestExecutionShare.model_name.human, errors: @test_execution_share.errors.full_messages.join(', '))
    end

    @test_execution = @test_execution_share.test_execution
    redirect_to test_execution_path(@test_execution)
  end

  def destroy
    @test_execution_share = TestExecutionShare.find(params[:id])
    authorize @test_execution_share

    @test_execution = @test_execution_share.test_execution
    @test_execution_share.destroy!

    flash[:notice] = t('shared.destroy_success', target: TestExecutionShare.model_name.human)
    redirect_to test_execution_path(@test_execution)
  end

  private

  def permitted_params
    params.require(:test_execution_share).permit(:name, :expire_at)
  end
end
