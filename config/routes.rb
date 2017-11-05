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
  resources :users

  get 'sessions/new'
  get '/prerequisites_add', to:'prerequisites#add'
  get '/prerequisites_index', to: 'prerequisites#index'
  get 'prerequisites_delete', to: 'prerequisites#delete'
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#hello'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/search/user', to: 'users#search'
  get '/enroll', to:'boards#enroll'
  get '/search', to:'cards#search'
end
