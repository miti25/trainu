Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end
  root 'pages#home'
  resources :recipes do
    collection do
      get 'search'
    end
  end
  delete 'recipe_image_delete/:id', to: 'recipes#image_destroy', as: 'recipe_image_destroy'
end
