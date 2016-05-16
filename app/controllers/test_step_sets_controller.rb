class TestStepSetsController < BaseController
  auto_decorate :test_step_sets, :test_step_set, only: [:index, :show]

  def index
    @test_step_sets = policy_scope(current_user.accessible_shared_test_step_sets).latest.page(params[:page]).per(20)
  end

  def show
    @test_step_set = SharedTestStepSet.find(params[:id])
    authorize @test_step_set

    @user_shared_test_step_sets = @test_step_set.user_shared_test_step_sets.limit(10)
  end

  def new
    @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    authorize @base_test_step_set, :show? if @base_test_step_set.present?

    @test_step_set = current_user.shared_test_step_sets.build
    authorize @test_step_set

    @base_test_step_set ||= @test_step_set
  end

  def create
    @base_test_step_set = (params[:base_test_step_set_id].presence && TestStepSet.find(params[:base_test_step_set_id]))
    authorize @base_test_step_set, :show? if @base_test_step_set.present?

    @test_step_set = current_user.shared_test_step_sets.build(permitted_create_params.merge(user: current_user, base_test_step_set: @base_test_step_set))
    authorize @test_step_set

    if @test_step_set.save
      flash[:notice] = t('shared.create_success', target: SharedTestStepSet.model_name.human)
      return redirect_to test_step_set_path(@test_step_set)
    end

    @base_test_step_set = @test_step_set
    render :new
  end

  def edit
    @test_step_set = SharedTestStepSet.find(params[:id])
    authorize @test_step_set
  end

  def update
    @test_step_set = SharedTestStepSet.find(params[:id])
    authorize @test_step_set

    if @test_step_set.update_attributes(permitted_update_params)
      flash[:notice] = t('shared.update_success', target: SharedTestStepSet.model_name.human)
      redirect_to test_step_set_path(@test_step_set)
      return
    end

    render :edit
  end

  def destroy
    @test_step_set = SharedTestStepSet.find(params[:id])
    authorize @test_step_set

    @test_step_set.destroy!

    flash[:notice] = t('shared.destroy_success', target: SharedTestStepSet.model_name.human)
    redirect_to test_step_sets_path
  end

  private

  def permitted_create_params
    params.require(:test_step_set).permit(
      :title,
      :description,
      test_steps_attributes:
        [:test_step_type, :_destroy, data: [:message, :selector, :javascript, :value, :url, :width, :height, :shared_test_step_set_id, :duration]]
    )
  end

  def permitted_update_params
    params.require(:test_step_set).permit(:title, :description)
  end
end
