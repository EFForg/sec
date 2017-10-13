class HomeController < ApplicationController
  def index
    @homepage = Homepage.
                preload(
                  featured_articles: :tags,
                  featured_topics: [:lessons, :tags],
                  featured_blog_posts: :tags
                ).
                take
  end
end
