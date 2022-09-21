# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :articles, except: %i[new edit]
      resources :users, only: :show
      get 'search', to: 'articles#search'
    end
  end
  root 'pages#index'
  get 'about', to: 'pages#about'
  resources :articles
  get 'search', to: 'articles#search'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'update', to: 'users#edit'
  resources :users, except: %i[new create edit]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
