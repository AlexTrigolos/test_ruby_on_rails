# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = t('.success')
      redirect_to users_path(user)
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

end
