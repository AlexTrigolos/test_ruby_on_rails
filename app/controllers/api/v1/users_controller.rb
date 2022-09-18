# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_articles = @user.articles.order(created_at: 'desc').paginate(page: params[:page], per_page: 3)
    formats_template
  end

  private

  def formats_template
    respond_to do |format|
      format.json
      format.xml
      format.pdf do
        @user_articles = @user.articles.order(created_at: 'desc')
        @truth_format = 'pdf'
        render pdf: "User articles count #{@user_articles.count}", template: 'users/show', formats: [:html],
               layout: 'pdf'
      end
    end
  end
end
