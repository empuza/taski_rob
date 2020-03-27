class User < ApplicationRecord
  include ActiveModel::Serializers::JSON

  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :username, :password_digest, presence: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  def attributes
    { id: id, username: username, email: email }
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: reset_password_token)
    self.reset_password_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end
end
