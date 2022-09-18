# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[edit update show destroy]

  def index
    @articles = Article.order(created_at: 'desc').paginate(page: params[:page], per_page: 3)
    respond_to do |format|
      format.html
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user if user_signed_in?
    if @article.save
      flash[:success] = t('.success')
      redirect_to article_path(@article)
    else
      render :new
    end
  end

  def show
    @article = Article.find_by(id: params[:id].to_i)
    respond_to do |format|
      format.html
    end
  end

  def edit
    return if user_signed_in? && @article.user == current_user

    flash[:danger] = t('.danger')
    redirect_to article_path(@article)
  end

  def update
    if @article.user_id == current_user&.id && @article.update(article_params)
      flash[:success] = t('.success')
      redirect_to article_path(@article)
    else
      flash.now[:danger] = t('.danger')
      render 'edit'
    end
  end

  def destroy
    if @article.user_id == current_user&.id
      @article.destroy
      flash[:success] = t('.success')
      redirect_to articles_path
    else
      flash[:danger] = t('.danger')
      redirect_to article_path(@article)
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
