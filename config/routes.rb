Rails.application.routes.draw do
  devise_for :users
  
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  
  # Rotas para tags
  resources :tags, only: [:index, :show]
  
  root 'welcome#index'
end
