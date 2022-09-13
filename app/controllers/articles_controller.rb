# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[edit update show destroy]

  def index
    @articles = Article.order(created_at: 'desc').paginate(page: params[:page], per_page: 3)
    respond_to do |format|
      format.html
      format.json{
        render index: @articles
      }
      format.xml{
        render index: @articles
      }
      format.pdf{
        @articles = Article.order(created_at: 'desc')
        @truth_format = 'pdf'
        render pdf: "Articles", template: 'articles/index', formats: [:html], layout: 'pdf'
      }
    end
    # respond_to do |format|
    #   format.html
    # format.json{
    #   render json: @articles
    # }
    # format.xml{
    #   render xml: @articles.as_json, template: 'articles/index'
    # }
    #   format.pdf{
    #     render pdf: @articles
    #   }
    # end
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

  def show
    @article = Article.find_by(id: params[:id].to_i)
    respond_to do |format|
      format.html
      format.json
      format.xml
      format.pdf{
        render pdf: "Article #{params[:id]}", template: 'articles/show', formats: [:html], layout: 'pdf'
      }
    end
  end

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
