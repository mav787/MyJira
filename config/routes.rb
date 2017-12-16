Rails.application.routes.draw do
  root 'application#hello'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server, at: '/cable'

  resources :sessions, only: [:create,:destroy]
  resources :application, only: [:hello]
  resources :boards
  resources :lists
  resources :cards, only: [:index, :create]
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

  get '/enroll', to:'boards#enroll'
  get '/board/stats', to: 'boards#stats'
  get '/git/board', to: 'boards#git'
  get '/gitconfig', to: 'boards#gitconfig'
  post '/github_webhooks', to: 'github_webhooks#github_push', defaults: { formats: :json }
  post '/email_processor', to:'griddler/emails#create'
  #authentication
  get 'auth/:provider/callback', to: 'sessions#google_create'
  get 'auth/failure', to: 'application#hello'
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'sessions/new'


  post '/card/move', to: 'cards#move'
  get '/card/show_modal.json', to: 'cards#show_modal'
  post '/card/edit_description.json', to: 'cards#edit_description'
  post '/tag/bind.json', to: 'tags#bind'
  post '/tag/unbind.json', to: 'tags#unbind'
  get '/card/can_move', to: 'cards#can_move'

  post '/tag/bind.json', to: 'tags#bind'
  post '/tag/unbind.json', to: 'tags#unbind'

  post 'addprereq.json', to:'prerequisites#add'
  post 'delprereq.json', to: 'prerequisites#delete'
  get 'searchresult', to: 'cards#searchmember'
  get 'search_for_assign', to: 'users#search_for_assign'
  get 'addmember', to: 'cards#addmember'
  post 'addmember.json', to: 'cards#addmember'
  get 'delmember', to: 'cards#deletemember'
  post 'delmember.json', to: 'cards#deletemember'
  root 'application#hello'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/search/user', to: 'users#search'
  get '/enroll', to:'boards#enroll'
  get '/search', to:'cards#search'

  get '/board/stats', to: 'boards#stats'



end
