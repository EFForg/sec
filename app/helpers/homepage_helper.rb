module HomepageHelper
  def homepage
    @homepage ||= Homepage.
      preload(
        featured_articles: :tags,
        featured_topics: [:lessons, :tags],
        featured_blog_posts: :tags
      ).take
  end

  def cache_key_for_homepage
    Homepage.all.cache_key
  end
end
