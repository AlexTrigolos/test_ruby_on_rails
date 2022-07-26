# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.order(created_at: 'asc').paginate(page: params[:page], per_page: 3)
  end

  def new; end

  def create
    @user = User.new(user_params)
    if @user.save
      authenticate_user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(params[:id])
    if @user&.update(user_params)
      flash[:success] = t('.success')
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @user_articles = @user.articles.order(created_at: 'desc').paginate(page: params[:page], per_page: 3)
    respond_to do |format|
      format.html
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def authenticate_user
    if @user.authenticate(user_params[:password])
      authenticated_user
    else
      flash.now[:warning] = t('.warning')
      render 'new'
    end
  end

  def authenticated_user
    session[:user_id] = @user.id
    flash[:success] = t('.success')
    redirect_to users_path(@user)
  end
end
