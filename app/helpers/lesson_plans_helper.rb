module LessonPlansHelper
  def lesson_plan_share_url!(lesson_plan)
    "#{lesson_plans_url}/#{lesson_plan.key!}"
  end
end
