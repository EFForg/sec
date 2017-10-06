class Topic < ApplicationRecord
  has_many :lessons
  accepts_nested_attributes_for :lessons, allow_destroy: true, reject_if: :all_blank

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true


  def unsaved_or_new_lesson
    lessons.find(&:new_record?) || lessons.new
  end

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end
end
