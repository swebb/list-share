Rails.application.routes.draw do
  resources :lists, only: [:create, :update, :destroy] do
    resources :items, only: :create
    resources :collaborators, only: [:create, :destroy]
  end
  resources :items, only: [:update, :destroy]
end
