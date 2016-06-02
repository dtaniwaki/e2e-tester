class UserNotificationSettingsController < BaseController
  before_action :set_records, only: [:index, :create]

  def index
    @tests = []
    @user_integrations = []
    if @test
      scope_base = current_user.user_notification_settings.with_test(@test)
      @user_integrations = current_user.user_integrations
    elsif @user_integration
      scope_base = current_user.user_notification_settings.with_user_integration(@user_integration)
      @tests = current_user.accessible_tests
    else
      scope_base = current_user.user_notification_settings
      @user_integrations = current_user.user_integrations
    end
    @user_notification_settings = policy_scope(scope_base).eager_load(:user_integration, :test)
    @new_setting = current_user.user_notification_settings.build(test: @test, user_integration: @user_integration)
  end

  def create
    @user_notification_setting = current_user.user_notification_settings.build(permitted_params)
    authorize @user_notification_setting

    @user_notification_setting.test = @test
    @user_notification_setting.user_integration = @user_integration

    if @user_notification_setting.save
      flash[:notice] = t('shared.create_success', target: UserNotificationSetting.model_name.human)
    else
      flash[:alert] = t('shared.create_failure', target: UserNotificationSetting.model_name.human, errors: @user_notification_setting.errors.full_messages.join(', '))
    end

    redirect_to request.referer || user_notification_settings_path
  end

  def update
    @user_notification_setting = UserNotificationSetting.find(params[:id])
    authorize @user_notification_setting

    @user_notification_setting.assign_attributes(permitted_params)

    if @user_notification_setting.save
      flash[:notice] = t('shared.update_success', target: UserNotificationSetting.model_name.human)
    else
      flash[:alert] = t('shared.update_failure', target: UserNotificationSetting.model_name.human, errors: @user_notification_setting.errors.full_messages.join(', '))
    end

    redirect_to request.referer || user_notification_settings_path
  end

  private

  def set_records
    if params[:test_id].present?
      @test = Test.find(params[:test_id])
      authorize @test
    end

    if params[:user_integration_id].present?
      @user_integration = UserIntegration::Base.find(params[:user_integration_id])
      authorize @user_integration
    end

    nil
  end

  def permitted_params
    params.require(:user_notification_setting).permit(:notify_test_execution_result)
  end
end
