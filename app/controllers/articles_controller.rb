class ArticlesController < ApplicationController
  include ContentPermissioning
  breadcrumbs "Security Education" => routes.root_path,
              "Articles" => routes.articles_path

  def index
    @sections = Article.published.
      includes(:section).
      references(:article_sections).
      order("article_sections.position, articles.section_position").
      group_by(&:section)
  end

  def show
    @article = Article.friendly.find(params[:id])
    protect_unpublished! @article
    og_object @article
    breadcrumbs @article.name
  end
end
