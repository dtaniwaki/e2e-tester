module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'public', only: [:new, :create]

    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:username, :name, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:username, :name, :email, :password, :password_confirmation, :current_password, user_variables_attributes: [:id, :name, :value, :_destroy])
      end
    end

    def after_inactive_sign_up_path_for(_resource)
      new_user_session_path
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
  end
end
