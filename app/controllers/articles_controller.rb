class ArticlesController < ApplicationController
  include ContentPermissioning
  breadcrumbs "Security Education" => routes.root_path,
              "Articles" => routes.articles_path

  def index
    @sections = Article.published.
      includes(:article_section).
      references(:article_sections).
      order("article_sections.position, articles.article_section_position").
      group_by(&:article_section)
  end

  def show
    @article = Article.friendly.find(params[:id])
    protect_unpublished! @article
    breadcrumbs @article.name
  end
end
