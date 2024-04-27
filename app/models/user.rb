class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  normalizes :email, with: ->email { email.strip }

  generates_token_for :password_reset, expires_in: 10.minutes do
    password_salt&.last(10)
  end
end
