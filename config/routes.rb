Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show'
      end
      namespace :items do
        get '/find_all', to: 'search#index'
      end
      resources :merchants do
        get '/items', to: 'merchants/items#index'
      end
      resources :items do
        get '/merchant', to: 'items/merchants#show'
      end
    end
  end
end
