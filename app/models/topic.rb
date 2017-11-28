class Topic < ApplicationRecord
  has_many :lessons, ->{ merge(Lesson.published) }
  has_many :admin_lessons, class_name: "Lesson", dependent: :destroy

  belongs_to :next_topic, class_name: "Topic", optional: true

  accepts_nested_attributes_for :admin_lessons

  acts_as_taggable

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  before_validation :nillify_empty_slug, prepend: true

  belongs_to :icon, optional: true

  include Publishing
  include Featuring

  include PgSearch
  multisearchable against: %i(name lesson_bodies tag_list),
                  if: :published?

  def nillify_empty_slug
    self.slug = nil if slug.blank?
  end

  def total_duration
    Duration.new(lessons.sum :duration)
  end

  private

  def lesson_bodies
    lessons.map(&:body).join(" ")
  end
end
