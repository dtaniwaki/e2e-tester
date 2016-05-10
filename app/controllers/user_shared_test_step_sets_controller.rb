class UserSharedTestStepSetsController < BaseController
  def index
    @shared_test_step_set = SharedTestStepSet.find(params[:test_step_set_id])
    authorize @shared_test_step_set, :show?
    @user_shared_test_step_sets = policy_scope(@shared_test_step_set.user_shared_test_step_sets).eager_load(:user).page(params[:page]).per(20)
  end

  def create
    @shared_test_step_set = SharedTestStepSet.find(params[:test_step_set_id])
    authorize @shared_test_step_set, :show?
    @user = User.find_or_invite_by({ email: params[:email] }, current_user)

    if @user.valid?
      @user_shared_test_step_set = @shared_test_step_set.user_shared_test_step_sets.with_user(@user).first_or_initialize
      authorize @user_shared_test_step_set
      if @user_shared_test_step_set.save
        flash[:notice] = 'Successfully invited the user'
      else
        flash[:alert] = 'Failed to invite the user'
      end
    else
      flash[:alert] = 'Failed to invite the user'
    end
    redirect_to test_step_set_path(@shared_test_step_set)
  end

  def destroy
    @user_shared_test_step_set = UserSharedTestStepSet.find(params[:id])
    authorize @user_shared_test_step_set

    @user_shared_test_step_set.destroy!

    flash[:notice] = 'Successfully unshared the test step set'

    redirect_to test_step_set_path(@user_shared_test_step_set.shared_test_step_set)
  end
end
