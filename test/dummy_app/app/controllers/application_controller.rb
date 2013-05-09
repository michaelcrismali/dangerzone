class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user = User.find_by_id(session[:user_id])
    @current_user = User.find_by_remember_token(cookies[:remember_token]) if @current_user.nil?
    if request.remote_ip == @current_user.try(:sign_in_ip)
      @current_user
    else
      @current_user ||= User.new(sign_in_ip: request.remote_ip)
    end

    # A more streamlined way to write the code above is below if you're interested.
    #
    # @current_user = User.find_by_id(session[:user_id]) || User.find_by_remember_token(cookies[:remember_token])
    # request.remote_ip == @current_user.try(:sign_in_ip) ? @current_user : @current_user ||= User.new(sign_in_ip: request.remote_ip)
  end

  def authorize_user
    redirect_to :sign_in if current_user.new_record?
  end
end
