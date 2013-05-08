class SessionsController < ApplicationController

  def create
    clear_cookies
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user.try(:confirmed) && @user.authenticate(params[:password])
      @user.sign_in(request.remote_ip)
      set_cookies(params[:remember_me])
      redirect_to :root, notice: "Sign-in successful."
    else
      redirect_to :sign_in, notice: "Sign-in unsuccessful."
    end
  end

  def destroy
    clear_cookies
    redirect_to :sign_in, notice: "Sign-out successful."
  end

  def new
    redirect_to :root if session[:user_id] || cookies[:remember_token]
  end

  private

  def set_cookies(remember_me)
    remember_me.present? ? cookies.permanent[:remember_token] = @user.remember_token : session[:user_id] = @user.id
  end

  def clear_cookies
    cookies.delete(:remember_token)
    reset_session
  end
end
