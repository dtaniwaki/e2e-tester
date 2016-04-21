class TestStepSetsController < BaseController
  def index
    @test_step_sets = policy_scope(current_user.accessible_shared_test_step_sets).latest.page(params[:page]).per(20)
  end

  def show
    @test_step_set = SharedTestStepSet.find(params[:id])
    authorize @test_step_set
  end

  def new
    @test_step_set = @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    @test_step_set ||= current_user.test_step_sets.build
    authorize @test_step_set
  end

  def create
    @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    authorize @base_test_step_set if @base_test_step_set.present?

    @test_step_set = current_user.shared_test_step_sets.build(permitted_params.merge(user: current_user, base_test_step_set: @base_test_step_set))
    authorize @test_step_set

    return redirect_to test_step_sets_path if @test_step_set.same_test_step_set?(@base_test_step_set)
    if @test_step_set.save
      flash[:notice] = 'Succesfully created new test step set'
      return redirect_to test_step_set_path(@test_step_set)
    end
    render :new
  end

  def destroy
    @test_step_set = SharedTestStepSet.find(params[:id])
    authorize @test_step_set

    @test_step_set.destroy!

    redirect_to test_step_sets_path
  end

  private

  def permitted_params
    params.require(:test_step_set).permit(:title, :test_steps_attributes)
  end
end
