class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true

  acts_as_taggable

  include Publishing
  include Featuring

  include PgSearch
  multisearchable against: %i(name body tag_list), if: :published?

  def self._to_partial_path
    "blog/blog_post"
  end

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end
end
