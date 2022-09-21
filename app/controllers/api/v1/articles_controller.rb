# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
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
    user = User.find_by(email: user_params[:email])
    unless user&.valid_password?(user_params[:password])
      return render json: { error: true, message: 'Invalid email address or password' }, status: :unauthorized
    end

    @article = Article.new(article_params)
    @article.user = user
    save_article
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
    user = User.find_by(email: user_params[:email])
    unless user&.valid_password?(user_params[:password])
      return render json: { error: true, message: 'Invalid email address or password' }, status: :unauthorized
    end

    unless @article.user_id == user.id
      return render json: { error: true, message: "Article was not updated, mb it's not your article" },
                    status: :forbidden
    end

    update_article
  end

  def destroy
    user = User.find_by(email: user_params[:email])
    unless user&.valid_password?(user_params[:password])
      return render json: { error: true, message: 'Invalid email address or password' }, status: :unauthorized
    end
    unless @article.user_id == user.id
      return render json: { error: true, message: "You can't deleted this article" }, status: :forbidden
    end

    @article.destroy
    render json: { error: false, message: 'Article was successfully destroyed' }, status: :ok
  end

  def search
    @option = search_params[:option]
    @query = search_params[:query]
    return redirect_to :articles if @query.empty?

    @search = Search.all
    @articles = search_by_ids if @option == 'id' || @option == 'user_id'
    @articles = search_by_article if @option == 'title' || @option == 'description'
    @articles = search_by_user if @option == 'username' || @option == 'email'
    @articles = search_by_everywhere if @option == 'everywhere'
    @articles = @articles.order(created_at: 'desc')
    respond_to do |format|
      format.json do
        @articles = @articles.order(created_at: 'desc').paginate(page: params[:page], per_page: 5)
        render :search
      end
      format.xml do
        @articles = @articles.order(created_at: 'desc').paginate(page: params[:page], per_page: 5)
        render :search
      end
      format.pdf do
        @truth_format = 'pdf'
        render pdf: 'Articles', template: 'articles/search', formats: [:html], layout: 'pdf'
      end
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def search_params
    params.require(:search).permit(:option, :query)
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_article
    @article = Article.find(params[:id])
  rescue StandardError
    if @article.nil?
      render json: { error: true, message: "You don't have an article with an ID #{params[:id]}" },
             status: :not_found
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

  def search_by_article(option: @option)
    Article.where("#{option} LIKE ?", "%#{@query}%")
  end

  def search_by_ids(option: @option)
    Article.where("#{option} = ?", @query.to_i)
  end

  def search_by_user(option: @option)
    Article.joins(:user).where("users.#{option} LIKE ?", "%#{@query}%")
  end

  def search_by_everywhere
    search_by_user(option: 'email')
      .or(search_by_user(option: 'username'))
      .or(search_by_article(option: 'title'))
      .or(search_by_article(option: 'description'))
  end
end
# rubocop:enable Style/ClassAndModuleChildren
