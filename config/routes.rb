Rails.application.routes.draw do
  resources :lists, only: [:create, :update, :destroy] do
    resources :items, only: :create
    resources :collaborators, only: :create
  end
  resources :items, only: [:update, :destroy]
end
