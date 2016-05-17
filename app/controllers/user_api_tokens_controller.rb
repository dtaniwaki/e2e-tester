class UserApiTokensController < BaseController
  def index
    @user_api_tokens = policy_scope(current_user.user_api_tokens).latest.page(params[:page]).per(20)
  end

  def create
    @user_api_token = current_user.user_api_tokens.build
    authorize @user_api_token

    @user_api_token.assign_attributes(permitted_params)

    if @user_api_token.save
      flash[:notice] = t('shared.create_success', target: UserApiToken.model_name.human)
    else
      flash[:alert] = t('shared.create_failure', target: UserApiToken.model_name.human, errors: @user_api_token.errors.full_messages.join(', '))
    end
    redirect_to user_api_tokens_path(current_user)
  end

  def update
    @user_api_token = UserApiToken.find(params[:id])
    authorize @user_api_token

    @user_api_token.assign_attributes(permitted_params)

    if @user_api_token.save
      flash[:notice] = t('shared.update_success', target: UserApiToken.model_name.human)
    else
      flash[:alert] = t('shared.update_failure', target: UserApiToken.model_name.human, errors: @user_api_token.errors.full_messages.join(', '))
    end

    redirect_to user_api_tokens_path(current_user)
  end

  def destroy
    @user_api_token = UserApiToken.find(params[:id])
    authorize @user_api_token

    @user_api_token.destroy!

    flash[:notice] = t('shared.destroy_success', target: UserApiToken.model_name.human)
    redirect_to user_api_tokens_path(current_user)
  end

  private

  def permitted_params
    params.require(:user_api_token).permit(:name)
  end
end
