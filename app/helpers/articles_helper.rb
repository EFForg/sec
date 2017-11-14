module ArticlesHelper
  def cache_key_for_articles(sections)
    [ArticleSection.all.cache_key, Article.all.cache_key]
  end

  def section_name(section)
    section.try(:name) || "Other Articles"
  end

  def section_id(section)
    name = section.try(:name) || "Other Articles"
    name.gsub(/\s+/, "_")
  end
end
