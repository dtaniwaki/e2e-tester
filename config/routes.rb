Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  if Settings.service.admin
    scope :admin do
      devise_for :admin_users, controllers: { omniauth_callbacks: 'admin_users/omniauth_callbacks' }
      as :admin_user do
        get 'sign_in', to: redirect(status: 302) { |_params, req|
          Rails.application.routes.url_helpers.admin_user_google_oauth2_omniauth_authorize_path(origin: req.referer)
        }, as: :new_admin_user_session
        delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_admin_user_session
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  authenticate :admin_user do
    if Settings.service.sidekiq
      require 'sidekiq/web'
      mount Sidekiq::Web => '/admin/sidekiq_web'
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    invitations: 'users/invitations'
  }

  resources :projects, shallow: true do
    resources :tests, only: [:index, :show, :destroy] do
      resources :test_executions, only: [:create, :index, :show] do
        member do
          get :done
        end
        resources :test_step_executions, only: [:show]
      end
      resources :user_tests, only: [:create, :update, :index]
    end
    resources :user_projects, only: [:create, :update, :index]
  end
  resources :user_credentials, only: [:index] do
    collection do
      resource :browserstack_credentials, only: [:create, :update, :destroy], path: :browserstack
    end
  end
  resources :test_step_sets
  namespace :misc, path: '' do
    get :tests
    get :test_executions
  end

  root to: 'misc#home'
end
