class LessonPlansController < ApplicationController
  def create
    @lesson_plan = LessonPlan.new(lesson_plan_params)

    if @lesson_plan.save
      session[:lesson_plan_id] = @lesson_plan.id
      redirect_back fallback_location: "/oh-no"
    end
  end

  def update
  end

  private

  def lesson_plan_params
    params[:lesson_plan].permit(lesson_plan_lessons_attributes: :lesson_id)
  end
end
