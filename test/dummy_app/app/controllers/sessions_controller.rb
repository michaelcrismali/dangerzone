class SessionsController < ApplicationController

  def create
    log_out
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user.try(:confirmed) && @user.authenticate(params[:password])
      @user.sign_in(request.remote_ip)
      session[:user_id] = @user.id
      cookies.permanent[:remember_token] = @user.remember_token if params[:remember_me].present?
      redirect_to :root, notice: "Sign-in successful."
    else
      redirect_to :sign_in, notice: "Sign-in unsuccessful."
    end
  end

  def destroy
    log_out
    redirect_to :sign_in, notice: "Sign-out successful."
  end

  def new
    redirect_to :root if session[:user_id] || cookies[:remember_token]
  end

  private

  def log_out
    cookies.delete(:remember_token)
    reset_session
  end
end
