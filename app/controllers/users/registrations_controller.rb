module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:name, :email, :password, :password_confirmation, :current_password)
      end
    end
  end
end
