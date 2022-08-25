class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]

  def index
    @articles = Article.order(created_at: "desc").paginate(page: params[:page], per_page: 3)
  end

  def new
    @article = Article.new
  end

  def create
    #render plain: params[:article].inspect
    @article = Article.new(article_params)
    @article.user = User.find(session[:user_id]) if session[:user_id] != nil
    if @article.save
      flash[:success] = "Article was successfully created"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def show
  end

  def edit
    if @article.user_id != session[:user_id]
      flash[:danger] = "You can't edit this article"
      redirect_to article_path(@article)
    end
  end

  def update
    if @article.user_id == session[:user_id] && @article.update(article_params)
      flash[:success] = "Article was updated"
      redirect_to article_path(@article)
    else
      flash[:danger] = "Article was not updated, mb it's not your article"
      render 'edit'
    end
  end

  def destroy
    if @article.user_id == session[:user_id]
      @article.destroy
      flash[:success] = "Article was deleted"
      redirect_to articles_path
    else
      flash[:danger] = "You can't deleted this article"
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
