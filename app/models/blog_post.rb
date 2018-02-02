class BlogPost < ApplicationRecord
  include FriendlyLocating

  acts_as_taggable

  include Publishing
  include Featuring

  include PgSearch
  multisearchable against: %i(name body tag_list), if: :published?

  def self._to_partial_path
    "blog/blog_post"
  end
end
