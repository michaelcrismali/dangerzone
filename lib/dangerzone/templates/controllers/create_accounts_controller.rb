class CreateAccountsController < ApplicationController

  def new

  end

  def create

    session[:name] = params[:user][:name]
    session[:email] = params[:user][:email]

    @user = User.find_by_email(params[:user][:email])

    if @user && !@user.confirmed
      @user.name = params[:user][:name]
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
    else
      @user = User.new(params[:user])
    end

    @user.reset_password_sent_at = Time.now

    @user.reset_password_token = SecureRandom.urlsafe_base64

    if @user.save
      UserMailer.account_confirmation_email(@user).deliver
      redirect_to check_your_email_url
    else
      render signup_url
    end

  end

  def resend_confirmation_email
    @user = User.find_by_email(params[:email])

    if @user && !@user.confirmed
      @user.reset_password_sent_at = Time.now

      @user.reset_password_token = SecureRandom.urlsafe_base64

      @user.save

      UserMailer.account_confirmation_email(@user).deliver
    end
    redirect_to check_your_email_url
  end

  def confirm
    @user = User.find_by_id(params[:id])

    if @user && (Time.now - @user.reset_password_sent_at) < 60.minutes && @user.reset_password_token == params[:reset_password_token]
      reset_session
      @user.confirmed = true
      @user.reset_password_sent_at = nil
      @user.reset_password_token = nil
      @user.remember_token = SecureRandom.urlsafe_base64
      @user.save
      session[:email] = @user.email
      redirect_to welcome_url
    else
      redirect_to signup_url
    end
  end

end
