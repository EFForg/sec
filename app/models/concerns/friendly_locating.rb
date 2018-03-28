module FriendlyLocating
  extend ActiveSupport::Concern

  included do
    extend FriendlyId

    friendly_id :name, use: [:slugged, :history]
    before_validation :nillify_empty_slug, prepend: true
  end


  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end
end
