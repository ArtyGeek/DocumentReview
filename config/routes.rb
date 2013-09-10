Documentreview::Application.routes.draw do

  root :to => "home#index"
  devise_for :users

  namespace :reviewer do
    resources :documents, only: [:index, :show]
    get 'documents/:id/send_for_publication', to: 'documents#send_for_publication', as: :send_for_publication
    get 'documents/:id/send_for_rework', to: 'documents#send_for_rework', as: :send_for_rework
  end

  namespace :author do
    resources :documents
    get 'documents/:id/send_for_review', to: 'documents#send_for_review', as: :send_for_review
  end

  namespace :admin do
    resources :users, except: [:index]
    resources :documents, only: [:show]
    get 'dashboard', to: 'dashboard#index'
    get 'documents/:id/publish', to: 'documents#publish', as: :publish
    get 'users/:id/add_user_role', to: 'users#add_user_role', as: :add_user_role
  end

  get ':id/comments', to: 'base#get_more_comments', as: :get_more_comments

end
