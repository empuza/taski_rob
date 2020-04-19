class User < ApplicationRecord
  include ActiveModel::Serializers::JSON

  has_secure_password
  has_many :tasks, dependent: :destroy

  enum role: %i[user manager admin].freeze

  validates :username, :password_digest, presence: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  def attributes
    { id: id, username: username, email: email, role: role }
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

  def generate_activation_token!
    begin
      self.activation_token = SecureRandom.urlsafe_base64
    end while User.exists?(activation_token: activation_token)
    self.activation_token_expires_at = 1.day.from_now
    save!
  end

  def clear_activation_token!
    self.activation_token = nil
    self.activation_token_expires_at = nil
    save!
  end
end
