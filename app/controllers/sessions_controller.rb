# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      create_user_session
    else
      flash.now[:danger] = t('.warning')
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t('.success')
    redirect_to root_path
  end

  private

  def create_user_session
    session[:user_id] = user.id
    flash[:success] = t('.success')
    redirect_to users_path(user)
  end
end
