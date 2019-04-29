Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/orders' => 'api#create_order'
  get '/inventories' => 'api#index'
  root 'roots#index'
end
