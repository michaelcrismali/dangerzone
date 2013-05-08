class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user = User.find_by_remember_token(cookies[:remember_token])
    @current_user ||= User.find_by_id(session[:user_id])
    request.remote_ip == @current_user.try(:sign_in_ip) ? nil : @current_user
  end

  def authorize_user
    redirect_to :sign_in unless current_user
  end
end
