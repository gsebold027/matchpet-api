Rails.application.routes.draw do
  resources :user, param: :_id
  resources :pet, param: :id

  get '/user/_id/favorites', to: 'user#favorites'
  post '/user/_id/favorites', to: 'user#add_favorite'
  delete '/user/_id/favorites', to: 'user#remove_favorite'

  patch '/pets/:id', to: 'pet#update'
  post '/auth/login', to: 'authentication#login'
  
  get '/genders', to: 'filter#gender'
  get '/sizes', to: 'filter#size'
  get '/species', to: 'filter#specie'
  get '/status', to: 'filter#status'
  
  get '/*a', to: 'application#not_found'
end
