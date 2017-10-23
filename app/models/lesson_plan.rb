class LessonPlan < ApplicationRecord
  has_many :lesson_plan_lessons
  has_many :lessons, through: :lesson_plan_lessons

  accepts_nested_attributes_for :lesson_plan_lessons, allow_destroy: true
end
