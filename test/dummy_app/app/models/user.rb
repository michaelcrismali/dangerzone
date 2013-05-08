class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_uniqueness_of :email
  validates :password, :presence => true, :if => :new_record?
  validates :password_confirmation, :presence => true, :if => :new_record?
  validates_format_of :email, :with => /.+@.+\..+/i

  before_save do
    self.email = self.email.try(:downcase)
  end

  def sign_in!(ip, pass_word)
    return false unless self.confirmed && self.authenticate(pass_word)
    self.sign_in_ip = ip
    self.sign_in_count += 1
    self.remember_token = SecureRandom.urlsafe_base64
    self.save
  end

  def update_reset_password_credentials
    self.reset_password_sent_at = Time.now
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.save
  end

  def confirm!(ip)
    self.sign_in_ip = ip
    self.confirmed = true
    self.reset_password_sent_at = nil
    self.reset_password_token = nil
    self.save
  end

  def in_time?
    (Time.now - self.reset_password_sent_at) < 24.hours if self.reset_password_sent_at
  end

  def token_matches?(token)
    self.reset_password_token == token
  end
end
