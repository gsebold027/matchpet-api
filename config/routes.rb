Rails.application.routes.draw do
  post '/api/v1/user', to: 'user#create'
  put '/api/v1/user/:id', to: 'user#update'
  delete 'api/v1/user/:id', to: 'user#delete'
end
