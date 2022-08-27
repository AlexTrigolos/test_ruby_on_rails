class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    if session[:user_id].present?
      @current_user ||= User.find(session[:user_id])
    elsif cookies.encrypted[:user_id].present?
      user = User.find_by(id: cookies.encrypted[:user_id])
      if user&.remember_token_authenticated?(cookies.encrypted[:remember_token])
        session[:user_id] = user.id
        flash[:success] = "You have logged in by cookies"
        @current_user ||= user
      end
    end
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end
end
