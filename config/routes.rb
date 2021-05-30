Rails.application.routes.draw do
  devise_for :users,
    defaults: { format: :json },
    path: '',
    path_names: {
      sign_in: 'api/v1/login',
      sign_out: 'api/v1/logout',
      registration: 'api/v1/signup'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations'
    }

  scope ':tenant_id' do
    namespace :api do
      namespace :v1 do
        get 'account', to: 'accounts#show'
        put 'account', to: 'accounts#update'
        patch 'account', to: 'accounts#update'
        resources :users, only: %w[index, show, create, update, delete]
        resources :products, only: %w[index, show, create, update, delete]
        resources :categories, only: %w[index, show, create, update, delete]
        resources :components, only: %w[index, show, create, update, delete]
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :accounts
        resources :users
      end
    end
  end
end
