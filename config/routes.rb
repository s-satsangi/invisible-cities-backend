Rails.application.routes.draw do
  get 'follow/create'

  post '/friends', to: 'follow#index'
  post 'numfriends', to: 'follow#number_for_profile'


  post 'create-message', to: 'message#create'
  # get 'message', to: 'message#index'
  post 'message', to: 'message#index'
  get 'message/update', to: 'message#update'
  get 'message/delete', to: 'message#delete'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/login', to: 'auth#create'
  get 'users/create', to: 'users#create'
  post 'users', to: 'users#create'
  get 'users', to: 'users#index'
  get 'users/delete', to: 'users#delete'
  get 'users/update', to: 'users#update'
end
