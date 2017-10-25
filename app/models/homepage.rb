class Homepage < ApplicationRecord
  has_many :featured_content

  has_many :featured_topic_content,
           ->{ where(content_type: "Topic") },
           class_name: "FeaturedContent"

  has_many :featured_article_content,
           ->{ where(content_type: "Article") },
           class_name: "FeaturedContent"

  has_many :featured_material_content,
           ->{ where(content_type: "Material") },
           class_name: "FeaturedContent"

  has_many :featured_blog_post_content,
          ->{ where(content_type: "BlogPost") },
          class_name: "FeaturedContent"

  has_many :featured_topics, through: :featured_topic_content,
           source: :content, source_type: "Topic",
           class_name: "Topic"

  has_many :featured_articles, through: :featured_article_content,
           source: :content, source_type: "Article",
           class_name: "Article"

  has_many :featured_materials, through: :featured_material_content,
           source: :content, source_type: "Material",
           class_name: "Material"

  has_many :featured_blog_posts, through: :featured_blog_post_content,
           source: :content, source_type: "BlogPost",
           class_name: "BlogPost"

  accepts_nested_attributes_for :featured_topic_content, allow_destroy: true
  accepts_nested_attributes_for :featured_article_content, allow_destroy: true
  accepts_nested_attributes_for :featured_material_content, allow_destroy: true
  accepts_nested_attributes_for :featured_blog_post_content, allow_destroy: true
end
