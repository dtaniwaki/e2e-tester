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
      flash[:notice] = 'Successfully created new share'
    else
      flash[:alert] = 'Failed to create new share'
    end
    redirect_to test_execution_path(@test_execution)
  end

  def update
    @test_execution_share = TestExecutionShare.find(params[:id])
    authorize @test_execution_share

    @test_execution_share.assign_attributes(permitted_params)

    if @test_execution_share.save
      flash[:notice] = 'Successfully updated the share'
    else
      flash[:alert] = 'Failed to create new share'
    end

    @test_execution = @test_execution_share.test_execution
    redirect_to test_execution_path(@test_execution)
  end

  def destroy
    @test_execution_share = TestExecutionShare.find(params[:id])
    authorize @test_execution_share

    @test_execution = @test_execution_share.test_execution
    @test_execution_share.destroy!

    flash[:notice] = 'Successfully deleted the share'
    redirect_to test_execution_path(@test_execution)
  end

  private

  def permitted_params
    params.require(:test_execution_share).permit(:name)
  end
end
