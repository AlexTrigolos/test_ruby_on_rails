# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    user = session[:user_id].present? ? user_from_session : user_from_token

    @current_user ||= user
  end

  def logged_in?
    !!current_user
  end

  def require_user
    return if logged_in?

    # rubocop:disable Rails/I18nLocaleTexts
    flash[:danger] = 'You must be logged in to perform that action'
    # rubocop:enable Rails/I18nLocaleTexts
    redirect_to root_path
  end

  private

  def user_from_session
    User.find(session[:user_id])
  end

  def user_from_token
    user = User.find_by(id: cookies.encrypted[:user_id])
    token = cookies.encrypted[:remember_token]

    return unless user&.remember_token_authenticated?(token)

    session[:user_id] = user.id
    # rubocop:disable Rails/I18nLocaleTexts
    flash[:success] = 'You have logged in by cookies'
    # rubocop:enable Rails/I18nLocaleTexts
    user
  end
end
