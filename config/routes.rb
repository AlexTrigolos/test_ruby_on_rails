# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :articles, defaults: {format: :json}
      # resources :users, except: [:new, :create, :edit]
    end
  end
  # Defines the root path route ("/")
  root 'pages#index'
  get 'about', to: 'pages#about'
  resources :articles
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'update', to: 'users#edit'
  resources :users, except: [:new, :create, :edit]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'


end
