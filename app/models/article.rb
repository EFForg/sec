class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true

  acts_as_taggable

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end
end
