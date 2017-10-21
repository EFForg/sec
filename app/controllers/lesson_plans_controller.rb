class LessonPlansController < ApplicationController
  def create
    @lesson_plan = LessonPlan.new(lesson_plan_params)

    if @lesson_plan.save
      session[:lesson_plan_id] = @lesson_plan.id
      redirect_back fallback_location: topics_path
    end
  end

  def update
    @lesson_plan = helpers.current_lesson_plan

    if @lesson_plan.update_attributes(lesson_plan_params)
      redirect_back fallback_location: topics_path # @todo go to lesson plan show
    end
  end

  private

  def lesson_plan_params
    params[:lesson_plan].permit(lesson_plan_lessons_attributes: :lesson_id)
  end
end
