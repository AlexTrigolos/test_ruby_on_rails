# frozen_string_literal: true

class Api::V1::ArticlesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_article, only: %i[update show destroy]

  def index
    @articles = Article.order(created_at: 'desc').paginate(page: params[:page], per_page: 3)
    respond_to do |format|
      format.json
      format.xml
      format.pdf do
        @articles = Article.order(created_at: 'desc')
        @truth_format = 'pdf'
        render pdf: 'Articles', template: 'articles/index', formats: [:html], layout: 'pdf'
      end
    end
  end

  def create
    if User.find_by(email: user_params[:email])&.valid_password?(user_params[:password])
      @article = Article.new(article_params)
      @article.user = User.find_by(email: user_params[:email])
      save_article
    else
      render json: { error: true, message: 'Invalid email address or password' }, status: :unauthorized
    end
  end

  def show
    @article = Article.find_by(id: params[:id].to_i)
    respond_to do |format|
      format.json
      format.xml
      format.pdf do
        render pdf: "Article #{params[:id]}", template: 'articles/show', formats: [:html], layout: 'pdf'
      end
    end
  end

  def update
    if User.find_by(email: user_params[:email])&.valid_password?(user_params[:password])
      if @article.user_id == User.find_by(email: user_params[:email]).id
        update_article
      else
        render json: { error: true, message: "Article was not updated, mb it's not your article" }, status: :forbidden
      end
    else
      render json: { error: true, message: 'Invalid email address or password' }, status: :unauthorized
    end
  end

  def destroy
    if User.find_by(email: user_params[:email])&.valid_password?(user_params[:password])
      if @article.user_id == User.find_by(email: user_params[:email]).id
        @article.destroy
        render json: { error: false, message: 'Article was successfully destroyed' }, status: :ok
      else
        render json: { error: true, message: "You can't deleted this article" }, status: :forbidden
      end
    else
      render json: { error: true, message: 'Invalid email address or password' }, status: :unauthorized
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
  rescue StandardError
    if @article.nil?
      render json: { error: true, message: "You don't have an article with an ID #{params[:id]}" }, status: :not_found
    end
  end

  def update_article
    if @article.update(article_params)
      render json: { error: false, message: 'Article was successfully updated' }, status: :ok
    else
      render json: { error: true, message: "Incorrect data: #{@article.errors.full_messages}" },
             status: :not_acceptable
    end
  end

  def save_article
    if @article.save
      render json: { error: false, message: 'Article was successfully created' }, status: :created
    else
      render json: { error: true, message: "Incorrect data: #{@article.errors.full_messages}" },
             status: :not_acceptable
    end
  end
end
