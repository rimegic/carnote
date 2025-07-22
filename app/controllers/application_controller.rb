class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Devise authentication
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Remove flash messages for sign in/out
  before_action :remove_devise_flash_messages

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  private
  
  def remove_devise_flash_messages
    if devise_controller?
      # Remove all Devise success messages that contain "signed"
      flash.delete(:notice) if flash[:notice]&.downcase&.include?("signed")
      
      # Remove specific Devise messages
      devise_messages_to_remove = [
        "Signed in successfully.",
        "Signed out successfully.", 
        "Welcome! You have signed up successfully.",
        "You have signed up successfully.",
        "Your account has been updated successfully.",
        "You will receive an email with instructions on how to reset your password in a few minutes.",
        "Your password has been changed successfully. You are now signed in.",
        "You have signed up successfully.",
        "Welcome! You have signed up successfully."
      ]
      
      devise_messages_to_remove.each do |message|
        flash.delete(:notice) if flash[:notice] == message
      end
    end
  end
end
