module AdminUsers
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def google_oauth2
      @admin_user = AdminUser.find_for_google_oauth2(request.env['omniauth.auth'], current_admin_user)

      if @admin_user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @admin_user, event: :authentication
      else
        set_flash_message :alert, :failure, kind: 'Google', reason: @admin_user.errors.full_messages.join(', ')
        redirect_to after_omniauth_failure_path_for(resource_name)
      end
    end

    protected

    def after_omniauth_failure_path_for(_scope)
      root_path
    end
  end
end
