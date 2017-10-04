Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: "home#index"

  resources :articles, only: [:index, :show]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
