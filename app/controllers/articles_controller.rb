class ArticlesController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Articles" => routes.articles_path

  def index
    @articles = Article.published.
                order(published_at: :desc).
                page(params[:page])
  end

  def show
    @article = Article.published.friendly.find(params[:id])
    breadcrumbs @article.name
  end
end
