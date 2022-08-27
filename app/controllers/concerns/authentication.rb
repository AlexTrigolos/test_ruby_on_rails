# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    public

    def remember(user)
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    def forget(user)
      user.forget_me
      cookies.delete :user_id
      cookies.delete :remember_token
    end
  end
  # rubocop:enable Metrics/BlockLength
end