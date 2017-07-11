Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'games#index'  
    resources :games do
    	resources :pieces, only: [:show, :update, :new, :create]
    end
    resources :dashboards, only: :index
    root 'games#index'
end
