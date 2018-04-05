module LessonPlanning
  extend ActiveSupport::Concern

  included do
    helper_method :current_lesson_plan
    helper_method :current_lesson_plan_lesson
  end

  def current_lesson_plan
    @_current_lesson_plan ||= LessonPlan.find_by(id: session[:lesson_plan_id])
    @_current_lesson_plan ||= LessonPlan.new
  end

  def current_lesson_plan_lesson(lesson)
    current_lesson_plan.
      lesson_plan_lessons.
      find_or_initialize_by(lesson_id: lesson.id)
  end
end
