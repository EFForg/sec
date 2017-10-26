require_dependency "duration"

class LessonPlan < ApplicationRecord
  has_many :lesson_plan_lessons
  has_many :lessons, through: :lesson_plan_lessons

  accepts_nested_attributes_for :lesson_plan_lessons, allow_destroy: true

  validates_uniqueness_of :key
  before_validation :set_key, on: :create

  def duration
    Duration.new(lessons.sum :duration)
  end

  def to_param
    key
  end

  private

  def set_key
    self.key = SecureRandom.urlsafe_base64
  end
end
