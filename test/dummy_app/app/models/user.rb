class User < ActiveRecord::Base

  has_secure_password

  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /.+@.+\..+/i

  before_save do
    self.email = self.email.try(:downcase)
  end

  def update_reset_password_credentials
    self.reset_password_sent_at = Time.now
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.save
  end

  def confirm(request_remote_ip)
    self.confirmed = true
    self.reset_password_sent_at = nil
    self.reset_password_token = nil
    self.sign_in_ip = request_remote_ip
    self.save
  end

end
