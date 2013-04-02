class CreateAccountsController < ApplicationController

  def create
    session[:email] = params[:user][:email]
    @user = User.new(params[:user])
    @user.email = @user.email.downcase
    @user.remember_token = SecureRandom.urlsafe_base64
    if @user.update_reset_password_credentials
      DangerzoneMailer.account_confirmation_email(@user).deliver
      redirect_to check_your_email_url, notice: "Registration successful."
    else
      redirect_to sign_up_url, notice: "Registration unsuccessful"
    end
  end

  def resend_confirmation_email
    @user = User.find_by_email(params[:email].downcase)
    if @user && !@user.confirmed
      @user.update_reset_password_credentials
      DangerzoneMailer.account_confirmation_email(@user).deliver
      redirect_to check_your_email_url, notice: "Resent confirmation email."
    else
      redirect_to check_your_email_url, notice: "Something went wrong."
    end
  end

  def confirm
    @user = User.find_by_id(params[:id])
    if @user && @user.has_token_and_is_in_time(params[:reset_password_token])
      reset_session
      @user.confirm(request.remote_ip)
      session[:user_id] = @user.id
      redirect_to root_url, notice: "User confirmation successful."
    else
      redirect_to sign_up_url, notice: "User confirmation unsuccessful."
    end
  end

  def new
  end

end
