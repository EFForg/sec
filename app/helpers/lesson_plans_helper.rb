module LessonPlansHelper
  def current_lesson_plan
    @current_lesson_plan ||= LessonPlan.find_by(id: session[:lesson_plan_id])
    @current_lesson_plan ||= LessonPlan.new
  end
end
