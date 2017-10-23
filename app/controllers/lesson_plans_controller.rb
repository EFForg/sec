class LessonPlansController < ApplicationController
  def show
    if params[:id]
      @lesson_plan = LessonPlan.find(params[:id])
    else
      @lesson_plan = helpers.current_lesson_plan
    end
  end

  def create
    @lesson_plan = LessonPlan.new(lesson_plan_params)

    if @lesson_plan.save
      session[:lesson_plan_id] = @lesson_plan.id

      respond_to do |format|
        format.html{ redirect_back fallback_location: topics_path }
        format.js{ render :update_form_state }
      end
    end
  end

  def update
    @lesson_plan = helpers.current_lesson_plan

    if @lesson_plan.update_attributes(lesson_plan_params)
      respond_to do |format|
        format.html { redirect_back fallback_location: "/lesson-plan" }
        format.js { render :update_form_state }
      end
    end
  end

  private

  def lesson_plan_params
    params[:lesson_plan].permit(lesson_plan_lessons_attributes: [:id, :_destroy, :lesson_id])
  end
end
