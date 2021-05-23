Rails.application.routes.draw do
  scope ':tenant_id' do
    namespace :api do
      namespace :v1 do
        # account
        get 'account', to: 'accounts#show'
        put 'account', to: 'accounts#update'
        patch 'account', to: 'accounts#update'
        
        resources :products
        resources :categories
        resources :components
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :accounts
      end
    end
  end
end
