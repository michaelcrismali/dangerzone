class ResetPasswordsController < ApplicationController

  def requested_reset_password
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user.try(:update_reset_password_credentials)
      DangerzoneMailer.reset_password_email(@user).deliver
      redirect_to :forgot_password, notice: "Reset password email successfully sent."
    else
      redirect_to :forgot_password, notice: "Reset password email failed to send."
    end
  end

  def reset_password_form
    @user = User.find_by_id(params[:id])
    unless @user.try(:in_time?) && @user.token_matches?(params[:reset_password_token])
      redirect_to :forgot_password, notice: "There was a problem, try having the email resent to you."
    end
  end

  def update_password
    @user = User.find_by_id(params[:id])
    if @user.try(:in_time?)
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      if @user.save
        reset_session
        session[:user_id] = @user.id
        redirect_to :root, notice: "Password successfully updated."
      else
        redirect_to reset_password_form_path(@user.id, @user.reset_password_token), notice: "Update password unsuccessful: password confirmation did not match password."
      end
    else
      redirect_to :forgot_password, notice: "Update password unsuccessful."
    end
  end

  def new
  end
end
