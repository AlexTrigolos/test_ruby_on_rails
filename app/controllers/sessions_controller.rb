class SessionsController < ApplicationController
  include Authentication
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      authenticated(user)
    else
      flash.now[:warning] = 'There was something wrong with your login information'
      render 'new'
    end
  end

  def destroy
    forget(current_user)
    session[:user_id] = nil
    flash[:success] = t('.success')
    redirect_to articles_path
  end

  private

  def authenticated(user)
    session[:user_id] = user.id
    remember(user) if params[:session][:remember_me] == '1'
    flash[:success] = t('.success')
    redirect_to users_path(user)
  end
end
