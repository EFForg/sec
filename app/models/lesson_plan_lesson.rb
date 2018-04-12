class LessonPlanLesson < ApplicationRecord
  belongs_to :lesson_plan, counter_cache: :lessons_count
  belongs_to :lesson

  scope :published, ->{
    joins(lesson: :topic).
      merge(Topic.published).
      merge(Lesson.published)
  }

  validate :lesson_must_be_published

  before_create :set_position_to_last

  private
  def lesson_must_be_published
    unless lesson.published?
      errors.add(:lesson, "must be published")
    end
  end

  # Add planned lessons to the end of the plan.
  def set_position_to_last
    if max_position = lesson_plan.lessons.maximum("position")
      self.position = max_position + 1
    end
  end
end
