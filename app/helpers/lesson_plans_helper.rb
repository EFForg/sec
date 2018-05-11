module LessonPlansHelper
  def lesson_plan_share_url!(lesson_plan, ext=nil)
    request.base_url + lesson_plan_share_path!(lesson_plan, ext)
  end

  def lesson_plan_share_path!(lesson_plan, ext=nil)
    "#{lesson_plans_path}/#{lesson_plan.key!}#{ext}"
  end
end
