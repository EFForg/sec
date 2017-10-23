class LessonPlanLesson < ApplicationRecord
  belongs_to :lesson_plan, counter_cache: :lessons_count
  belongs_to :lesson

  scope :published, ->{ joins(lesson: :topic).merge(Topic.published) }
end
