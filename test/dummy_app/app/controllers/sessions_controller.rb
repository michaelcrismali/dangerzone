class SessionsController < ApplicationController

  def create
    clear_cookies # see below for the definition
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user.try(:sign_in!, request.remote_ip, params[:password])
      set_cookies(params[:remember_me])
      redirect_to :root, notice: "Sign-in successful."
    else
      redirect_to :sign_in, notice: "Sign-in unsuccessful."
    end
  end

  def destroy
    clear_cookies # see below for the definition
    redirect_to :sign_in, notice: "Sign-out successful."
  end

  def new
    # Below is an inline if statement syntax
    redirect_to :root if session[:user_id] || cookies[:remember_token]

    # It could also be written like this:
    #
    # if session[:user_id] || cookies[:remember_token]
    #   redirect_to :root
    # end
  end

  # These methods are marked as private since they're helper methods
  # and not controller actions associated with routes.

  private

  def set_cookies(remember_me)
    if remember_me.present?
      cookies.permanent[:remember_token] = @user.remember_token
    else
      session[:user_id] = @user.id
    end

    # A more streamlined way to write the code above is below if you're interested.
    #
    # remember_me.present? ? cookies.permanent[:remember_token] = @user.remember_token : session[:user_id] = @user.id
  end

  def clear_cookies
    cookies.delete(:remember_token)
    reset_session # This reset_session method isn't defined here because it's
                  # provided by rails. It takes the session hash and deletes everything in it
  end
end
