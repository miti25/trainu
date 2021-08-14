Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end
  resources :recipes do
    resources :favorites, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end
  delete 'recipe_image_delete/:id', to: 'recipes#image_destroy', as: 'recipe_image_destroy'
  root 'pages#home'
end
