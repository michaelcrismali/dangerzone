class ApplicationController < ActionController::Base
  protect_from_forgery

  # the before filter belongs in any controller your users
  # need to be logged in to access
  # before_filter :authorize_user

  def current_user
    @current_user = User.find_by_remember_token(cookies[:remember_token])
    @current_user ||= User.find_by_id(session[:user_id])
    @current_user = nil if @current_user && request.remote_ip != @current_user.current_sign_in_ip
    @current_user
  end

  def authorize_user
    redirect_to sign_in_url if current_user.nil?
  end

end
