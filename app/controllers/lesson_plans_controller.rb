class LessonPlansController < ApplicationController
  include Zipping
  include LessonPlanning

  def show
    if params[:id]
      @lesson_plan = LessonPlan.find_by(key: params[:id])
    else
      @lesson_plan = current_lesson_plan
    end
    @lesson_plan_lessons = @lesson_plan.lesson_plan_lessons.published

    respond_to do |format|
      format.html
      format.pdf do
        if Rails.env.development?
          @lesson_plan.recreate_pdf_file
          send_file(@lesson_plan.pdf.path, disposition: "inline")
        else
          redirect_to @lesson_plan.pdf.url
        end
      end

      format.zip do
        files = @lesson_plan_lessons.map(&:lesson).map(&:pdf)

        unless files.all?(&:present?)
          raise Exception.new("lesson pdf not present")
        end

        send_archive(files)
      end
    end
  end

  def update
    @lesson_plan = current_lesson_plan

    if @lesson_plan.update_attributes(lesson_plan_params)
      respond_to do |format|
        format.html { redirect_back fallback_location: "/lesson-plan" }
        format.js{ render "update_form_state" } # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end
  end

  def create_lesson
    @lesson_plan = current_lesson_plan!
    @lesson_plan.lessons << Lesson.find(params[:lesson_id])

    render @lesson_plan
  end

  def destroy_lesson
    @lesson_plan = current_lesson_plan

    @lesson_plan.lesson_plan_lessons.
      where(lesson_id: params[:lesson_id]).destroy_all

    render @lesson_plan
  end

  private

  def lesson_plan_params
    params[:lesson_plan].permit(lesson_plan_lessons_attributes: [:id, :_destroy, :lesson_id])
  end
end
