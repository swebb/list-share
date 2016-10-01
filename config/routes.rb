Rails.application.routes.draw do
  resources :lists, only: :create
end
