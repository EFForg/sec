Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: "home#index"

  post "/dismiss", as: "dismiss_modal", to: "application#dismiss_modal"

  resources :articles, only: [:index, :show] do
    post :preview, on: :member
  end
  post '/articles_overview/preview', to: 'articles#index_preview'

  scope :blog, controller: "blog" do
    get "/", as: "blog", action: "index"
    get "/:id", as: "blog_post", action: "show"
  end

  resources :topics, only: [:index, :show] do
    post :preview, on: :member
    resources :lessons, path: "", only: [:show] do
      post :preview, on: :member
    end
  end

  resources :lesson_plans, path: "/lesson-plans", only: [:create, :update] do
    post :lessons, to: "lesson_plans#create_lesson"
    delete :lessons, to: "lesson_plans#destroy_lesson"
    collection do
      get ":key", to: "lesson_plans#show"
    end
  end

  get "/lesson-plan", as: :current_lesson_plan, to: "lesson_plans#show"

  resources :materials, only: [:index, :show]

  resources :glossary, only: [:index, :show]

  scope "/feedback", as: :feedback, controller: "feedback" do
    root action: :new
    post "/", action: :create, as: :create
    get :thanks
  end

  get "/search", as: :search, to: "search#results"

  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
  get "/feed" => redirect("https://www.eff.org/deeplinks.xml?field_issue_tid=11461")

  devise_for :admin_users, ActiveAdmin::Devise.config.deep_merge(
               controllers: { :invitations => "user_invitations" }
             )
  ActiveAdmin.routes(self)

  ["credits", "translations"].each do |page|
    get page, as: page, to: "pages#show", defaults: { page_id: page }
  end
end
