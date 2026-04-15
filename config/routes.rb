Rails.application.routes.draw do
  devise_for :users
  root "welcome#index"
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
end

