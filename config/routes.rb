Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'share#index'
  get 'flask', to: 'share#flask'
  post 'share/:session', to: 'share#share'
end
