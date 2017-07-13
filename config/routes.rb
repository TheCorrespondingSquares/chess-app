Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_facebook_session
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'games#index'  
    resources :games do
    	resources :pieces
    end
    resources :dashboards, only: :index
    root 'games#index'
end
