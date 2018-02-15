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

  resources :materials, only: [:index, :show]

  resources :glossary, only: [:index, :show]

  get "/credits", as: :credits, to: "credits#index"
  get "/search", as: :search, to: "search#index"

  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
  get "/feed" => redirect("https://www.eff.org/deeplinks.xml?field_issue_tid=11461")

  devise_for :admin_users, ActiveAdmin::Devise.config.deep_merge(
               controllers: { :invitations => "user_invitations" }
             )
  ActiveAdmin.routes(self)
end
