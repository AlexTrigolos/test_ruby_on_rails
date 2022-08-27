# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token

  has_secure_password
  has_many :articles, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
  before_save { self.email = email.downcase }

  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, digest(remember_token)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def forget_me
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, nil
    # rubocop:enable Rails/SkipsModelValidations
    self.remember_token = nil
  end

  def remember_token_authenticated?(remember_token)
    return false if remember_token_digest.blank?

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
  end

  private

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
