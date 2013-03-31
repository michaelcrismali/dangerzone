class ResetPasswordsController < ApplicationController

  def new
  end

  def send_reset_password
    @user = User.find_by_email(params[:email])

    @user.reset_password_sent_at = Time.now

    @user.reset_password_token = SecureRandom.urlsafe_base64

    if @user.save
      UserMailer.reset_password_email(@user).deliver
    else
      redirect_to forgot_password_url
    end

  end

  def reset_password_form
    @user = User.find_by_id(params[:id])

    if @user && (Time.now - @user.reset_password_sent_at) < 60.minutes && @user.reset_password_token == params[:reset_password_token]
      session[:reset_password_user_id] = @user.id
    else
      redirect_to forgot_password_url
    end

  end

  def update_password
    @user = User.find_by_id(session[:reset_password_user_id])

    if @user && (Time.now - @user.reset_password_sent_at) < 60.minutes
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.reset_password_token = SecureRandom.urlsafe_base64
      if @user.save
        reset_session
        session[:user_id] = @user.id
        redirect_to root_url
      else
        redirect_to send_reset_password_url
      end
    else
      redirect_to send_reset_password_url
    end

  end

end
