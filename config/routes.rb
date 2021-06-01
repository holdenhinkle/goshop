Rails.application.routes.draw do
  scope ':tenant_id' do
    devise_for :users,
    defaults: { format: :json },
    path: '',
    path_names: {
      sign_in: 'api/v1/users/login',
      sign_out: 'api/v1/users/logout',
      password: 'api/v1/users/recover',
      confirmation: 'api/v1/users/confirm',
      registration: 'api/v1/users/register'
    },
    controllers: {
      sessions: 'api/v1/sessions',
      registrations: 'api/v1/registrations'
    }

    namespace :api do
      namespace :v1 do
        get 'account', to: 'accounts#show'
        put 'account', to: 'accounts#update'
        patch 'account', to: 'accounts#update'
        resources :users, only: [:index, :show, :update, :delete]
        resources :products, only: [:index, :show, :create, :update, :delete]
        resources :categories, only: [:index, :show, :create, :update, :delete]
        resources :components, only: [:index, :show, :create, :update, :delete]
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :accounts
        resources :users, only: [:index, :show, :update, :delete]
      end
    end
  end
end
