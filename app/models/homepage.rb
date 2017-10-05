class Homepage < ApplicationRecord
  has_many :promoted_content

  has_many :promoted_topic_content,
           ->{ where(content_type: "Topic") },
           class_name: "PromotedContent"

  has_many :promoted_article_content,
           ->{ where(content_type: "Article") },
           class_name: "PromotedContent"

  has_one :promoted_blog_post_content,
          ->{ where(content_type: "BlogPost") },
          class_name: "PromotedContent"

  has_many :promoted_topics, through: :promoted_topic_content,
           source: :content, source_type: "Topic",
           class_name: "Topic"

  has_many :promoted_articles, through: :promoted_article_content,
           source: :content, source_type: "Article",
           class_name: "Article"

  accepts_nested_attributes_for :promoted_topic_content, allow_destroy: true
  accepts_nested_attributes_for :promoted_article_content, allow_destroy: true

  def promoted_materials
    [
      OpenStruct.new(name: "Downloadable PDFs and slides", to_partial_path: "materials/material"),
      OpenStruct.new(name: "Install Tools", to_partial_path: "materials/material")
    ]
  end

  def promoted_blog_post
    BlogPost.new(name: "Highlighted post")
  end
end
