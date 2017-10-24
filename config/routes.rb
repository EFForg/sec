Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: "home#index"

  resources :articles, only: [:index, :show]

  scope :blog, controller: "blog" do
    get "/", as: "blog", action: "index"
    get "/:id", as: "blog_post", action: "show"
  end

  resources :topics, only: [:index, :show] do
    resources :lessons, path: "", only: [:show]
  end

  resources :lesson_plans, path: "/lesson-plans", only: [:create, :update, :show]
  get "/lesson-plan", as: :current_lesson_plan, to: "lesson_plans#show"

  get "/search", as: :search, to: "search#index"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
