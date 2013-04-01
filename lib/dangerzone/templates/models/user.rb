class User < ActiveRecord::Base

  has_secure_password

  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /.+@.+\..+/i

  def update_reset_password_credentials
    @user.reset_password_sent_at = Time.now
    @user.reset_password_token = SecureRandom.urlsafe_base64
    @user.save
  end

  def confirm(request_remote_ip)
    @user.confirmed = true
    @user.reset_password_sent_at = nil
    @user.reset_password_token = nil
    @user.sign_in_ip = request_remote_ip
    @user.save
  end

end
