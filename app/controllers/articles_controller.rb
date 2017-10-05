class ArticlesController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Articles" => routes.articles_path

  def index
    @articles = Article.all.page(params[:page])
  end

  def show
    @article = Article.find(params[:id])
    breadcrumbs @article.name
  end
end
