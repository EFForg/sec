class Article < ApplicationRecord
  include FriendlyLocating

  include Publishing
  include Featuring
  include Previewing

  acts_as_taggable

  include PgSearch
  multisearchable against: %i(name body tag_list), if: :published?

  belongs_to :section, class_name: "ArticleSection", optional: true

  belongs_to :next_article, class_name: "Article", optional: true
end
