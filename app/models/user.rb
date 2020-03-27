class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :username, :password_digest, presence: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }
end
