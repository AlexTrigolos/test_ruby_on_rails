# frozen_string_literal: true

class UsersController < ApplicationController
  include Authentication
  def index
    @users = User.order(created_at: 'asc').paginate(page: params[:page], per_page: 3)
  end

  def new
    # @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user.authenticate(user_params[:password])
        authenticated(@user)
      else
        flash[:warning] = t('.warning')
        render 'new'
      end
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
      format.json
      format.xml
      format.pdf{
        @user_articles = @user.articles.order(created_at: 'desc')
        @truth_format = 'pdf'
        render pdf: "User articles count #{@user_articles.count}", template: 'users/show', formats: [:html], layout: 'pdf'
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def authenticated(user)
    session[:user_id] = user.id
    remember(user) if user_params[:remember_me] == '1'
    flash[:success] = "Welcome to the alpha blog #{@user.username}"
    redirect_to users_path(user)
  end
end
