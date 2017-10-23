class LessonPlanLesson < ApplicationRecord
  belongs_to :lesson_plan, counter_cache: :lessons_count
  belongs_to :lesson

  scope :published, ->{ joins(lesson: :topic).merge(Topic.published) }

  validate :lesson_must_be_published

  def lesson_must_be_published
    unless lesson.published?
      errors.add(:lesson, "must be published")
    end
  end
end
