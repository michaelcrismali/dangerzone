class DangerzoneMailer < ActionMailer::Base
  default from: "YOUR SITE"

  def account_confirmation_email(user)
    @user = user
    mail to: @user.email, subject: "Confirm your account"
  end

  def reset_password_email(user)
    @user = user
    mail to: @user.email, subject: "Reset your password"
  end

end
