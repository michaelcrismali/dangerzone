class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    return @current_user if @current_user
    @current_user = User.find_by_id(session[:user_id]) || User.find_by_remember_token(cookies[:remember_token])
    if request.remote_ip == @current_user.try(:sign_in_ip)
      @current_user
    else
      @current_user = User.new(sign_in_ip: request.remote_ip)
    end
  end

  def authorize_user
    redirect_to :sign_in if current_user.new_record?
  end
end
