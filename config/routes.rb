Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do 
    namespace :v1 do 
      resources :merchants, only: [:index, :show] do 
        collection do 
          get "find", to: "merchants/search#search"
        end
        resources :items, only: [:index], controller: 'merchants/items'
      end

      resources :items do 
        resources :merchant, only: [:index], controller: 'items/merchants'
      end
    end
  end
end
