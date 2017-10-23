class LessonPlansController < ApplicationController
  include ContentPermissioning

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
        format.html{ redirect_back fallback_location: topics_path } # @todo go to lesson plan show
        format.js{ render :update_form_state }
      end
    end
  end

  private

  def lesson_plan_params
    params = self.params[:lesson_plan].
      permit(lesson_plan_lessons_attributes: [:id, :_destroy, :lesson_id])

    params.tap do |lesson_plan|
      lesson_plan["lesson_plan_lessons_attributes"].each do |plan_lesson|
         protect_unpublished!(Lesson.find(plan_lesson["lesson_id"]))
      end
    end
  end
end
