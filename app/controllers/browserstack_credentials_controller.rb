class BrowserstackCredentialsController < BaseController
  def create
    @credential = current_user.build_browserstack_credential(browserstack_permitted_params)
    authorize @credential

    if @credential.save
      flash[:notice] = t('shared.create_success', target: UserCredential::Browserstack.model_name.human)
    else
      flash[:alert] = t('shared.update_failure', target: UserCredential::Browserstack.model_name.human, errors: @credential.errors.full_messages.join(', '))
    end

    redirect_to origin || user_credentials_path
  end

  def update
    @credential = current_user.browserstack_credential
    @credential.assign_attributes(browserstack_permitted_params)
    authorize @credential

    if @credential.save
      flash[:notice] = t('shared.update_success', target: UserCredential::Browserstack.model_name.human)
    else
      flash[:alert] = t('shared.update_failure', target: UserCredential::Browserstack.model_name.human, errors: @credential.errors.full_messages.join(', '))
    end
    redirect_to origin || user_credentials_path
  end

  def destroy
    @credential = current_user.browserstack_credential
    if @credential
      authorize @credential

      @credential.destroy!
      flash[:notice] = t('shared.destroy_success', target: UserCredential::Browserstack.model_name.human)
    end

    redirect_to origin || user_credentials_path
  end

  private

  def browserstack_permitted_params
    params.require(:browserstack).permit(:username, :password)
  end
end
