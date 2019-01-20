class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # To permit additional params for devise controller
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def goto_main
    flash[:alert] = "Couldn't find the event."
    redirect_to events_path
  end
end
