class ArticleSection < ApplicationRecord
  has_many :articles, ->{ order(:article_section_position) }

  accepts_nested_attributes_for :articles
end
