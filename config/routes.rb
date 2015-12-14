Rails.application.routes.draw do
  resources :document_imports, except: [:update] do
    resources :document_import_rows, path: :rows, only: [:show, :create, :update, :destroy]
    post :publish, on: :member
  end

  devise_for :users

  authenticated :user do
    root 'welcome#index'
  end

  root 'visitor/welcome#index', as: :visitor_root
end
