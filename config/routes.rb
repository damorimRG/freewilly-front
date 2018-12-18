Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'share#index'
  get 'faq', to: 'share#faq', as: 'faq'
  get 'tutorial', to: 'share#tutorial', as: 'tutorial'
  get '404', to: 'share#not_found'
  get '/create', to: 'share#create', as: 'create_session'
  post 'share/:session', to: 'share#share'
  post '/killall', to: 'share#kill_containers'
  get ':session', to: 'share#shared', as: 'run_instance'
end
