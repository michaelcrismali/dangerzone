class CreateAccountsController < ApplicationController

  def create
    # session[:email] = params[:user][:email]
    @user = User.new(params[:user])
    @user.remember_token = SecureRandom.urlsafe_base64
    if @user.update_reset_password_credentials
      DangerzoneMailer.account_confirmation_email(@user).deliver
      render :check_your_email, notice: "Registration successful."
    else
      render :new, notice: "Registration unsuccessful"
      # redirect_to sign_up_url, notice: "Registration unsuccessful"
    end
  end

  def resend_confirmation_email
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user && !@user.confirmed
      @user.update_reset_password_credentials
      DangerzoneMailer.account_confirmation_email(@user).deliver
    end
    render :check_your_email, notice: "Resent confirmation email."
  end

  def confirm
    @user = User.find_by_id(params[:id])
    if @user && @user.in_time? && @user.token_matches?(params[:reset_password_token])
      reset_session
      @user.confirm(request.remote_ip)
      session[:user_id] = @user.id
      redirect_to root_url, notice: "User confirmation successful."
    else
      render :new, notice: "User confirmation unsuccessful."
    end
  end

  def new
  end

end
