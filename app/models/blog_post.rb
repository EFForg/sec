class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true

  include Publishing

  def self._to_partial_path
    "blog/blog_post"
  end

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end
end
