module LessonPlanning
  extend ActiveSupport::Concern

  included do
    helper_method :current_lesson_plan
    helper_method :current_planned_lesson
    helper_method :current_lesson_plan_missing_lesson_in_topic?
  end

  def current_lesson_plan
    @_current_lesson_plan ||= LessonPlan.find_by(id: session[:lesson_plan_id])
    @_current_lesson_plan ||= LessonPlan.new
  end

  def current_lesson_plan!
    current_lesson_plan.tap do |lesson_plan|
      lesson_plan.save!
      session[:lesson_plan_id] = lesson_plan.id
    end
  end

  def current_planned_lesson(lesson)
    current_lesson_plan.
      planned_lessons.
      find_or_initialize_by(lesson_id: lesson.id)
  end

  def current_lesson_plan_missing_lesson_in_topic?(topic)
    topic.lessons.each do |lesson|
      if !current_lesson_plan.lessons.include?(lesson)
        return true
      end
    end
    return false
  end

end
