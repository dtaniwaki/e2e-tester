class BrowserstackCredentialsController < BaseController
  def create
    @credential = current_user.build_browserstack_credential(browserstack_permitted_params)
    authorize @credential

    if @credential.save
      flash[:notice] = 'Successfully created the credential'
    else
      flash[:alert] = 'Failed to create the credential'
    end

    redirect_to origin || user_credentials_path
  end

  def update
    @credential = current_user.browserstack_credential
    @credential.assign_attributes(browserstack_permitted_params)
    authorize @credential

    if @credential.save
      flash[:notice] = 'Successfully updated the credential'
    else
      flash[:alert] = 'Failed to update the credential'
    end
    redirect_to origin || user_credentials_path
  end

  def destroy
    @credential = current_user.browserstack_credential
    if @credential
      authorize @credential

      @credential.destroy!
      flash[:notice] = 'Successfully deleted the credential'
    end

    redirect_to origin || user_credentials_path
  end

  private

  def browserstack_permitted_params
    params.require(:browserstack).permit(:username, :password)
  end

  def origin
    url = params[:origin]
    if url
      url = URI.parse(url)
      url.host == request.host && url.scheme == request.scheme ? url.to_s : nil
    end
  end
end
