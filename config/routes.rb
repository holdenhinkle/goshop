Rails.application.routes.draw do
  resources :accounts

  scope ':tenant_id' do
    namespace :api do
      namespace :v1 do
        resources :products
        resources :categories
        resources :components
      end
    end
  end
end
