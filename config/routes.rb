Rails.application.routes.draw do
  get 'lists/show'
  get 'lists/create'
  get 'lists/destroy'
  get '/search', to: 'searches#search'
  get 'likes/create'
  get 'likes/destroy'
  root 'static_pages#home'
  get '/contact',   to: 'static_pages#contact'
  get '/signup',    to: 'users#new'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  post '/guest',    to: 'sessions#guest'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :posts, only: %i[create destroy show]
  resources :relationships, only: %i[create destroy]
  resources :likes, only: %i[create destroy]
  resources :comments, only: %i[create destroy]
  resources :list, only: %i[create destroy show]
end
