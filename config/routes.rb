Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_facebook_session
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :games do
    	resources :pieces, only: [:show, :update]
    end
    resources :dashboards, only: :index
    root 'games#index'
end
