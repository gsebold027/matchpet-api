Rails.application.routes.draw do
  resources :user, param: :_id
  # post '/api/v1/user', to: 'user#create'
  # put '/api/v1/user/:id', to: 'user#update'
  # delete 'api/v1/user/:id', to: 'user#delete'
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
