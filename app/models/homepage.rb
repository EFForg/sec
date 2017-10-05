class Homepage < ApplicationRecord
  has_many :featured_content

  has_many :featured_topic_content,
           ->{ where(content_type: "Topic") },
           class_name: "FeaturedContent"

  has_many :featured_article_content,
           ->{ where(content_type: "Article") },
           class_name: "FeaturedContent"

  has_one :featured_blog_post_content,
          ->{ where(content_type: "BlogPost") },
          class_name: "FeaturedContent"

  has_many :featured_topics, through: :featured_topic_content,
           source: :content, source_type: "Topic",
           class_name: "Topic"

  has_many :featured_articles, through: :featured_article_content,
           source: :content, source_type: "Article",
           class_name: "Article"

  accepts_nested_attributes_for :featured_topic_content, allow_destroy: true
  accepts_nested_attributes_for :featured_article_content, allow_destroy: true

  def featured_materials
    [
      OpenStruct.new(name: "Downloadable PDFs and slides", to_partial_path: "materials/material"),
      OpenStruct.new(name: "Install Tools", to_partial_path: "materials/material")
    ]
  end

  def featured_blog_post
    BlogPost.new(name: "Highlighted post")
  end
end
