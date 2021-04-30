Rails.application.routes.draw do
  scope ':account' do
    namespace :api do
      namespace :v1 do
        resources :products
        resources :categories
        resources :components
      end
    end
  end
end
