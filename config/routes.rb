Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/orders' => 'api#create_order'
  get '/inventories' => 'api#index'
  get '/stock' => 'roots#index'
  root 'roots#inicio'
  get '/jobs', to:'jobs#index'

end
