Rails.application.routes.draw do
  get 'prerequisites/add'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :boards
  resources :lists
  resources :cards
  resources :tags
  resources :comments
  resources :notifications do
    collection do
        post :mark_as_read
    end
  end
  resources :users do
    member do
      get :confirm_email
    end
  end

  resources :sessions, only: [:create,:destroy]
  resources :application, only: [:hello]

  get 'auth/:provider/callback', to: 'sessions#google_create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get 'sessions/new'
  get '/prerequisites_add', to:'prerequisites#add'
  get '/prerequisites_index', to: 'prerequisites#index'
  get 'prerequisites_delete', to: 'prerequisites#delete'

  root 'application#hello'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/search/user', to: 'users#search'
  get '/enroll', to:'boards#enroll'
  get '/search', to:'cards#search'
  post '/card/move', to: 'cards#move'
end
