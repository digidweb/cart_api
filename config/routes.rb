Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Raiz
  root 'products#index'

  # Produtos
  resources :products, only: [:index, :show]

  # Carrinho (singular resource)
  resource :cart, only: [:show, :create], controller: 'carts' do
    post 'clear', on: :collection
    post 'complete', on: :collection
  end

  # Itens do carrinho
  resources :cart_items, only: [:create, :update, :destroy]
end
