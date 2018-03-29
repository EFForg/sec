ActiveAdmin.register_page "Articles Overview" do
  menu parent: "Pages"

  page_action :update, method: :patch do
    page = ArticlesPage.find_by!(name: "articles-overview")

    unless page.update(body: params[:articles_page][:body])
      messages = page.errors.full_messages.join
      flash[:error] = "Error: " + messages
      return redirect_to admin_articles_overview_path
    end

    ArticleSection.where(id: params[:deleted_section_ids]).destroy_all

    if params[:article_sections]
      params[:article_sections].each_pair do |_, attrs|
        if attrs[:id]
          section = ArticleSection.find(attrs[:id])
        else
          section = ArticleSection.create!(name: attrs[:name])
        end

        attrs = attrs.permit(
          :id, :position,
          articles_attributes: [
            :id, :section_id, :section_position
          ]
        )

        attrs[:articles_attributes].reject! do |k, article|
          article["id"].to_i.zero?
        end

        if attrs[:articles_attributes].present?
          ids = []
          attrs[:articles_attributes].each_pair do |_, a|
            ids << a["id"]
          end

          Article.where(id: ids).update_all section_id: section.id
        end
        unless section.update(attrs)
          messages = section.errors.full_messages.join
          flash[:error] = "Error: " + messages
          return redirect_to admin_articles_overview_path
        end
      end
    end

    flash[:success] = "Content has been successfully updated."
    redirect_to admin_articles_overview_path
  end

  content do
    render "admin/pages/articles_overview",
      page: ArticlesPage.find_by!(name: "articles-overview")
  end

  class ArticlesPage < Page
    def sections
      @sections ||= ArticleSection.order(:position)
    end
  end
end
