Rails.application.routes.draw do
  resources :user, param: :_id
  resources :pet, param: :id

  patch '/pets/:id', to: 'pet#update'
  post '/auth/login', to: 'authentication#login'
  
  get '/genders', to: 'filter#gender'
  get '/sizes', to: 'filter#size'
  get '/species', to: 'filter#specie'
  get '/status', to: 'filter#status'
  
  get '/*a', to: 'application#not_found'
end
