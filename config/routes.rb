Rails.application.routes.draw do
  resources :lists, only: [:create, :update, :destroy] do
    resources :items, only: :create
  end
end
