class User < ActiveRecord::Base
  has_secure_password

  # attr_accessible 'whitelists' certain attributes of your model so they're mass assignable
  # So right now User.new(email: 'email@example.com', password: '1234', password_confirmation: '1234')
  # is valid, but User.new(sign_in_ip: 'ip address') is not because :sign_in_ip is not listed
  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_uniqueness_of :email
  validates :password, presence: true, if: :new_record?
  validates :password_confirmation, presence: true, if: :new_record?
  validates_format_of :email, with: /.+@.+\..+/i

  before_save { self.email = self.email.try(:downcase) }

  def update_reset_password_credentials
    self.reset_password_sent_at = Time.now
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.save
  end

  # There's a ruby convention that methods that have 'side effects,'
  # change values you may not expect or permanently change some values
  # (like the methods below that change things in the database) should be
  # named with a '!' at the end.
  def sign_in!(ip, password_param)
    return false unless self.confirmed && self.authenticate(password_param)
    self.sign_in_ip = ip
    self.sign_in_count += 1
    self.remember_token = SecureRandom.urlsafe_base64
    self.save
  end

  def confirm!(ip)
    self.sign_in_ip = ip
    self.confirmed = true
    self.reset_password_sent_at = nil
    self.reset_password_token = nil
    self.save
  end

  # Rubyists have a convention that methods that end with a question mark generally return true or false
  # like these methods below do.
  def in_time?
    (Time.now - self.reset_password_sent_at) < 24.hours if self.reset_password_sent_at
  end

  def token_matches?(token)
    self.reset_password_token == token
  end
end
