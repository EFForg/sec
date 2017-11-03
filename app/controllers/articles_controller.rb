class ArticlesController < ApplicationController
  include ContentPermissioning
  breadcrumbs "Security Education" => routes.root_path,
              "Articles" => routes.articles_path

  def index
    @articles = Article.published.
                order(created_at: :desc).
                page(params[:page])
  end

  def show
    @article = Article.friendly.find(params[:id])
    protect_unpublished! @article
    breadcrumbs @article.name
  end
end
