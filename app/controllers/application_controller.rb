class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    #include Devise::Controllers::Helpers
    before_action :configure_permitted_parameters, if: :devise_controller?
    protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end
end
