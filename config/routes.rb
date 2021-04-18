Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end

  root 'pages#home'
  resources :recipes
end
