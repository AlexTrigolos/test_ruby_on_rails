# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :trackable,
         :recoverable, :rememberable, :validatable
  has_many :articles, dependent: :destroy
  # has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
  before_save { self.email = email.downcase }
end
