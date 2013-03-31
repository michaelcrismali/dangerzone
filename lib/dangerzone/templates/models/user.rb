class User < ActiveRecord::Base

  has_secure_password

  attr_accessible :email, :password, :password_confirmation, :confirmed, :remember_token

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /.+@.+\..+/i

  def sign_in(remote_ip_from_request)
    @user.last_sign_in_ip = @user.current_sign_in_ip
    @user.current_sign_in_ip = remote_ip_from_request #must be a parameter
    @user.last_sign_in_at = @user.current_sign_in_at
    @user.current_sign_in_at = Time.now
    @user.sign_in_count = @user.sign_in_count + 1
    @user.save
  end

  def remember_me
    @user.remember_token = SecureRandom.urlsafe_base64
    @user.save
  end

end
