class UserTestVersionsController < BaseController
  def create
    @test_version = TestVersion.find(params[:test_version_id])
    authorize @test_version, :show?
    @user = User.find_or_invite_by({ email: params[:email] }, current_user)

    if @user.valid?
      @user_test_version = @test_version.user_test_versions.with_user(@user).first_or_initialize
      authorize @user_test_version
      @user_test_version.assigned_by = current_user
      if @user_test_version.save
        flash[:notice] = t('shared.invite_success', target: User.model_name.human)
      else
        flash[:alert] = t('shared.invite_failure', target: User.model_name.human, errors: @user_test_version.errors.full_messages.join(', '))
      end
    else
      flash[:alert] = t('shared.invite_failure', target: User.model_name.human, errors: @user.errors.full_messages.join(', '))
    end
    redirect_to test_version_position_path(@test_version)
  end

  def update
    @user_test_version = UserTestVersion.find(params[:id])
    authorize @user_test_version

    if @user_test_version.update_attributes(permitted_params)
      flash[:notice] = t('shared.update_success', target: UserTestVersion.model_name.human)
    else
      flash[:alert] = t('shared.update_failure', target: UserTestVersion.model_name.human, errors: @user_test_version.errors.full_messages.join(', '))
    end
    redirect_to test_version_position_path(@user_test_version.test_version)
  end

  def index
    @test_version = TestVersion.find(params[:test_version_id])
    authorize @test_version, :show?
    @user_test_versions = policy_scope(@test_version.user_test_versions).eager_load(:user).page(params[:page]).per(20)
  end

  def destroy
    @user_test_version = UserTestVersion.find(params[:id])
    authorize @user_test_version

    @user_test_version.destroy!

    flash[:notice] = t('shared.destroy_success', target: UserTestVersion.model_name.human)

    redirect_to test_version_position_path(@user_test_version.test_version)
  end

  private

  def permitted_params
    params.require(:user_test_version).permit(user_test_version_variables_attributes: [:id, :name, :value, :_destroy])
  end
end
