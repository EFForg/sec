module ArticlesHelper
  def cache_key_for_articles(sections)
    [ArticleSection.all.cache_key, Article.all.cache_key]
  end
end
