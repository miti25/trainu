Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end
  root 'pages#home'
  resources :recipes do
    resources :howtos, only: %i[create update destroy new]
    collection do
      get 'search'
    end
  end
end
