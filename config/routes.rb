Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :auth, defaults: { format: :json } do
    post :login, :register 
  end

end
