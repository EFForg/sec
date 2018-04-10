class ArticlesPage < Page
  def sections
    @sections ||= ArticleSection.order(:position)
  end
end
