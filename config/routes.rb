Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, module: :merchants do
        resources :items, only: :index
      end
      resources :items, module: :items do
        resource :merchant, only: :show
      end
    end
  end
end
