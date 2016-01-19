Rails.application.routes.draw do
  mount API::V1::Root => '/api/v1'

  devise_for :users

  # Routes that explicitly ask for authentication.
  # These routes prevent visitor routes from using the same URL.
  authenticate :user do
    resources :documents, only: [:index]

    resources :document_exports, except: [:edit, :update] do
      get :download, on: :member
    end

    resources :document_imports, except: [:edit, :update] do
      post :publish, on: :member
    end

    resources :repositories
  end

  # Routes that are unavailable for visitors.
  # These routes allow visitor routes using the same URL.
  authenticated :user do
    root 'welcome#index'
  end

  # Public (visitor) routes.
  root 'visitor/welcome#index', as: :visitor_root

  namespace :refine do
    namespace :reconcile do
      get  :grades, to: 'grades#index'
      post :grades, to: 'grades#index'
    end
  end
end
