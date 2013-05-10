class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email,
    :password,
    :password_confirmation,
    :reset_password_token,
    :reset_password_sent_at,
    :sign_in_ip,
    :sign_in_count,
    :confirmed,
    :remember_token

  validates_presence_of :email
  validates_uniqueness_of :email
  validates :password, :password, presence: true, if: :new_record?
  validates_format_of :email, with: /.+@.+\..+/i

  before_save { self.email = self.email.try(:downcase) }

  def update_reset_password_credentials
    update_attributes(
      reset_password_sent_at: Time.now,
      reset_password_token:  SecureRandom.urlsafe_base64)
  end

  def sign_in!(ip, password_param)
    return false unless self.confirmed && self.authenticate(password_param)
    update_attributes(
      sign_in_ip: ip,
      sign_in_count: (self.sign_in_count + 1),
      remember_token: SecureRandom.urlsafe_base64)
  end

  def confirm!(ip)
    update_attributes(
      sign_in_ip: ip,
      confirmed: true,
      reset_password_sent_at: nil,
      reset_password_token: nil)
  end

  def in_time?
    (Time.now - self.reset_password_sent_at) < 24.hours if self.reset_password_sent_at
  end

  def token_matches?(token)
    self.reset_password_token == token
  end
end
