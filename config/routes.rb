Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#top'

  get '/login', to:'user_sessions#new'
  post '/login', to:'user_sessions#create'
  delete '/logout', to:'user_sessions#destroy' 
  
  resources :users, only: %i[new create]

  resources :posts, shallow: true do
    resources :comments, only: %i[create destroy]
  end
end
