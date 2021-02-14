Rails.application.routes.draw do
  get 'follow/create'
  get '/logout', to: 'auth#destroy'
  get '/groups', to: 'user_group#index'
  post '/groups', to: 'user_group#create'
  get '/deluser', to: 'users#delete'
  post '/delmsg', to: 'message#delete'

  post '/block', to: 'follow#block'
  post '/add_friend', to: 'follow#add_friend'
  post '/friends', to: 'follow#index'
  get '/numfriends', to: 'follow#number_for_profile'
  post '/reply_pos', to: 'follow#reply_pos'
  post '/reply_neg', to: 'follow#reply_neg'
  post '/create-message', to: 'message#create'
  # get 'message', to: 'message#index'
  get 'message', to: 'message#index'
  get 'message/update', to: 'message#update'
  get 'message/delete', to: 'message#delete'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/login', to: 'auth#create'
  get '/users', to: 'users#index'
  post '/users', to: 'users#create'
  get '/users/create', to: 'users#create'
  get '/users/profile', to: 'users#profile'
  get '/users/update', to: 'users#update'
  post '/finduser', to: 'users#search'

end
