class Topic < ApplicationRecord
  has_many :lessons
  accepts_nested_attributes_for :lessons, allow_destroy: true, reject_if: :deep_all_blank

  acts_as_taggable

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true

  mount_uploader :icon, IconUploader

  include Publishing
  include Featuring

  include PgSearch
  multisearchable against: %i(name lesson_bodies tag_list),
                  if: :published?

  def deep_all_blank(attributes)
    attributes.all? do |key, value|
      return true if key == "_destory" || value == [""] || value.blank?
      all_blank_or_empty_multiselect value if value.is_a? Hash
    end
  end

  def unsaved_or_new_lesson
    lessons.find(&:new_record?) || lessons.new
  end

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end

  def duration
    lessons.first.duration
  end

  private

  def lesson_bodies
    lessons.map(&:body).join(" ")
  end
end
