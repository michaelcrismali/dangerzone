class SessionsController < ApplicationController

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password]) && @user.confirmed
      @user.sign_in(request.remote_ip)
      if params[:remember_me] == '1'
        @user.remember_me
        cookies.permanent[:remember_token] = @user.remember_token
      else
        session[:user_id] = @user.id
      end
      redirect_to root_url, :notice => "Sign-in successful."
    else
      redirect_to signin_url, :notice => "Sign-in unsuccessful."
    end
  end

  def destroy
    cookies.delete(:remember_token)
    reset_session
    redirect_to signin_url
  end

  def new
  end

  def welcome
  end

end
