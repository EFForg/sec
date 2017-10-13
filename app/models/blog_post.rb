class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true

  acts_as_taggable

  include Publishing
  include Featuring

  def self._to_partial_path
    "blog/blog_post"
  end

  def author
    OpenStruct.new(name: "So and So")
  end

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end
end
