Rails.application.routes.draw do
  resources :user, param: :_id
  resources :pet, param: :id

  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'

end
