module LessonPlansHelper
  def current_lesson_plan
    @current_lesson_plan ||= LessonPlan.find_by(id: session[:lesson_plan_id])
    @current_lesson_plan ||= LessonPlan.new
  end

  def current_lesson_plan_lesson(lesson)
    current_lesson_plan.
      lesson_plan_lessons.
      find_or_initialize_by(lesson_id: lesson.id)
  end
end
