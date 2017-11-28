class Material < ApplicationRecord
  include Publishing

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true

  has_many :uploads
  accepts_nested_attributes_for :uploads, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :name

  def first_file
    return if uploads.empty?
    uploads.first.file
  end

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end
end
