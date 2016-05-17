Rails.application.routes.draw do
  if Settings.service.admin || Settings.service.sidekiq
    scope :admin do
      devise_for :admin_users, ActiveAdmin::Devise.config
    end
  end

  ActiveAdmin.routes(self) if Settings.service.admin

  authenticate :admin_user do
    if Settings.service.sidekiq
      require 'sidekiq/web'
      mount Sidekiq::Web => '/admin/sidekiq_web'
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    invitations: 'users/invitations'
  }

  resources :tests, shallow: true do
    resources :user_tests, only: [:create, :update, :index, :destroy]
    resources :test_versions, only: [] do
      resources :test_executions, only: [:create, :index, :show] do
        member do
          get :done
        end
        resources :test_step_executions, only: [:show]
        resources :test_execution_shares, only: [:index, :create, :update, :destroy]
      end
      resources :user_test_versions, only: [:create, :update, :index, :destroy]
    end
  end
  resources :user_integrations, only: [:index] do
    collection do
      resources :slack_integrations, path: 'slack'
    end
  end
  get 'user_integrations/:type/:id', to: -> { root_path }, as: :polymorphic_user_integration # Fake route for polymorphic routes
  resources :tests, only: [] do
    get 'versions' => 'test_versions#index', as: :test_versions
    get ':num' => 'test_versions#show', as: :test_version
    delete ':num' => 'test_versions#destroy'
  end
  resources :user_credentials, only: [:index] do
    collection do
      resource :browserstack_credentials, only: [:create, :update, :destroy], path: :browserstack
    end
  end
  resources :test_step_sets, shallow: true do
    resources :user_shared_test_step_sets, only: [:index, :create, :destroy]
  end
  resources :user_api_tokens, path: 'api_tokens', only: [:index, :create, :update, :destroy]
  namespace :misc, path: '' do
    get :assigned_tests
    get :test_executions
  end

  root to: 'misc#home'
end
