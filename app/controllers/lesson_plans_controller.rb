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

  def create
    @lesson_plan = LessonPlan.new(lesson_plan_params)

    if @lesson_plan.save
      session[:lesson_plan_id] = @lesson_plan.id

      respond_to do |format|
        format.html{ redirect_back fallback_location: topics_path }
        format.js{ render "update_form_state" } # rubocop:disable GitHub/RailsControllerRenderPathsExist
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
    params[:lesson_plan] = {
      lesson_plan_lessons_attributes: [
        { lesson_id: params[:lesson_id] }
      ]
    }

    if helpers.current_lesson_plan.persisted?
      update
    else
      create
    end
  end

  def destroy_lesson
    lesson = Lesson.find(params[:lesson_id])
    lesson_plan_lesson = helpers.current_lesson_plan_lesson(lesson)

    params[:lesson_plan] = {
      lesson_plan_lessons_attributes: [
        id: lesson_plan_lesson.id,
        _destroy: "1"
      ]
    }

    update
  end

  private

  def lesson_plan_params
    params[:lesson_plan].permit(lesson_plan_lessons_attributes: [:id, :_destroy, :lesson_id])
  end
end
