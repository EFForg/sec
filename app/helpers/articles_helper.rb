module ArticlesHelper
  def cache_key_for_articles(articles)
    [Article.all.cache_key, articles.current_page]
  end
end
