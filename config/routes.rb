Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/orders' => 'api#create_order'
  get '/inventories' => 'api#index'
  get '/stock' => 'roots#index'
  root 'shop#products'
  get '/jobs', to:'jobs#index'

  get '/products' => 'shop#products'
  get '/checkout' => 'shop#checkout'

  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }

end
