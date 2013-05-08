class CreateAccountsController < ApplicationController

  def create
    @user = User.new(params[:user])
    if @user.update_reset_password_credentials
      DangerzoneMailer.account_confirmation_email(@user).deliver
      redirect_to :check_your_email, notice: "Registration successful."
    else
      redirect_to :sign_up, notice: "Registration unsuccessful"
    end
  end

  def resend_confirmation_email
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user && !@user.confirmed && @user.update_reset_password_credentials
      DangerzoneMailer.account_confirmation_email(@user).deliver
      redirect_to :check_your_email, notice: 'Resent confirmation email.'
    else
      redirect_to :check_your_email, notice: 'Unable to resend confirmation email.'
    end
  end

  def confirm
    @user = User.find_by_id(params[:id])
    if @user && @user.in_time? && @user.token_matches?(params[:reset_password_token])
      reset_session
      @user.confirm!(request.remote_ip)
      session[:user_id] = @user.id
      redirect_to :root, notice: "User confirmation successful."
    else
      redirect_to :sign_up, notice: "User confirmation unsuccessful."
    end
  end

  def new
  end
end
