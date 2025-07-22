class SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    flash.delete(:notice)
    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    flash.delete(:notice)
    root_path
  end
end