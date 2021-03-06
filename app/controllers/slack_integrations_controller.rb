class SlackIntegrationsController < BaseController
  def show
    @integration = UserIntegration::Slack.find(params[:id])
    authorize @integration
  end

  def new
    @integration = current_user.user_integrations.build.becomes! UserIntegration::Slack
    authorize @integration
  end

  def create
    @integration = current_user.user_integrations.build.becomes! UserIntegration::Slack
    authorize @integration

    @integration.assign_attributes(permitted_params)

    if @integration.save
      flash[:notice] = t('shared.create_success', target: UserIntegration::Slack.model_name.human)
      redirect_to origin || slack_integration_path(@integration)
      return
    end

    render :new
  end

  def edit
    @integration = UserIntegration::Slack.find(params[:id])
    authorize @integration
  end

  def update
    @integration = UserIntegration::Slack.find(params[:id])
    authorize @integration

    @integration.assign_attributes(permitted_params)

    if @integration.save
      flash[:notice] = t('shared.update_success', target: UserIntegration::Slack.model_name.human)
      redirect_to origin || slack_integration_path(@integration)
      return
    end

    render :edit
  end

  def destroy
    @integration = UserIntegration::Slack.find(params[:id])
    authorize @integration

    @integration.destroy!

    flash[:notice] = t('shared.destroy_success', target: UserIntegration::Slack.model_name.human)
    redirect_to origin || user_integrations_path
  end

  private

  def permitted_params
    params.require(:integration).permit(:name, :webhook_url)
  end
end
