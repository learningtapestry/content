Rails.application.routes.draw do
  mount API::V1::Root => '/api/v1'

  resources :documents, only: [:index]

  resources :document_exports, except: [:edit, :update] do
    get :download, on: :member
  end
  
  resources :document_imports, except: [:edit, :update] do
    post :publish, on: :member
  end
  
  resources :repositories

  devise_for :users

  authenticated :user do
    root 'welcome#index'
  end

  root 'visitor/welcome#index', as: :visitor_root
end
