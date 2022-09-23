# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def articles_index
    @option = params[:option]
    @query = params[:query]
    return @articles = Article.order(created_at: 'desc') if @query.blank?

    @articles = search_by_article if @option == 'title' || @option == 'description'
    @articles = search_by_user if @option == 'username' || @option == 'email'
    @articles = search_by_everywhere if @option == 'everywhere'
    @articles
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email)
    end
  end

  private

  def search_by_article(option: @option)
    Article.where("#{option} LIKE ?", "%#{Article.sanitize_sql_like(@query)}%")
  end

  def search_by_user(option: @option)
    Article.joins(:user).where("users.#{option} LIKE ?", "%#{Article.sanitize_sql_like(@query)}%")
  end

  def search_by_everywhere
    search_by_user(option: 'email')
      .or(search_by_user(option: 'username'))
      .or(search_by_article(option: 'title'))
      .or(search_by_article(option: 'description'))
  end
end
