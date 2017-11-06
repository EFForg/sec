ActiveAdmin.register_page "Articles Overview" do
  menu parent: "Pages"

  page_action :update, method: :patch do
    intro = ManagedContent.find_by!(region: "articles-intro")

    unless intro.update(body: params[:page][:intro])
      messages = intro.errors.full_messages.join
      flash[:error] = "Error: " + messages
      return redirect_to admin_articles_overview_path
    end

    params[:article_sections].each_pair do |_, attrs|
      section = ArticleSection.find(attrs[:id])

      attrs = attrs.permit(
        :id, :position,
        articles_attributes: [
          :id, :article_section_id, :article_section_position
        ]
      )

      unless section.update(attrs)
        messages = section.errors.full_messages.join
        flash[:error] = "Error: " + messages
        return redirect_to admin_articles_overview_path
      end
    end

    flash[:success] = "Content has been successfully updated."
    redirect_to admin_articles_overview_path
  end

  content do
    render "admin/pages/articles_overview", page: Page.new
  end


  class Page
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    def persisted?
      true
    end

    def intro
      ManagedContent.find_by(region: "articles-intro").try(:body)
    end

    def sections
      @sections ||= ArticleSection.order(:position)
    end
  end
end
