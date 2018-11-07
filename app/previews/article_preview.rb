class ArticlePreview < ActivePreview::Preview
  def ignored_associations
    %w(slugs pg_search_document).freeze
  end
end
