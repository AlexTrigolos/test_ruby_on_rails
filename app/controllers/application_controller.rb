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

    flash[:danger] = t('.danger')
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
    flash[:success] = t('.success')
    user
  end
end
