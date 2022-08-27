# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[edit update show destroy]

  def index
    @articles = Article.order(created_at: 'desc').paginate(page: params[:page], per_page: 3)
  end

  def new
    @article = Article.new
  end

  def create
    # render plain: params[:article].inspect
    @article = Article.new(article_params)
    @article.user = User.find(session[:user_id]) unless session[:user_id].nil?
    if @article.save
      flash[:success] = t('.success')
      redirect_to article_path(@article)
    else
      render :new
    end
  end

  def show; end

  def edit
    return unless @article.user_id != session[:user_id]

    flash[:danger] = t('.danger')
    redirect_to article_path(@article)
  end

  def update
    if @article.user_id == session[:user_id] && @article.update(article_params)
      flash[:success] = t('.success')
      redirect_to article_path(@article)
    else
      flash[:danger] = t('.danger')
      render 'edit'
    end
  end

  def destroy
    if @article.user_id == session[:user_id]
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

  def set_article
    @article = Article.find(params[:id])
  end
end
