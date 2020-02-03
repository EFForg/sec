class ArticlesController < ApplicationController
  include ContentPermissioning
  include Pdfing

  breadcrumbs "Security Education" => routes.root_path,
              "Articles" => routes.articles_path

  def index
    @page = Page.find_by!(name: "articles-overview")
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

    respond_to do |format|
      format.html
      format.md
      format.pdf do
        if Rails.env.development?
          UpdateArticlePdf.perform_now(@article.id)
          send_file(@article.reload.pdf.path, disposition: "inline")
        else
          redirect_to @article.pdf.url
        end
      end
    end
  end

  def preview
    protect_previews!
    @preview = true
    @article = Article.friendly.find(params[:id]).preview(preview_params.to_h)
    @preview_params = { article: preview_params.to_h }
    og_object @article
    breadcrumbs @article.name
    render "articles/show"
  end

  def index_preview
    protect_previews!
    @preview = true
    @page = Page.find_by!(name: "articles-overview")
    @page = @page.preview(overview_preview_params.to_h)
    @preview_params = { articles_page: overview_preview_params.to_h }
    @sections = Article.published.
      includes(:section).
      references(:article_sections).
      order("article_sections.position, articles.section_position").
      group_by(&:section)
    render "articles/index"
  end

  private

  def preview_params
    params.require(:article).permit(:name, :authorship, :summary, :body,
                                    :next_article_id)
  end

  def overview_preview_params
    params.require(:articles_page).permit(:body)
  end
end
