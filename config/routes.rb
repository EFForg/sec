Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: "home#index"

  resources :articles, only: [:index, :show]

  scope :blog, controller: "blog" do
    get "/", as: "blog", action: "index"
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
