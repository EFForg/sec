class LessonPlansController < ApplicationController
  include Zipping
  include LessonPlanning

  skip_before_action :verify_authenticity_token
  before_action :verify_request_origin

  def show
    if params[:key]
      @lesson_plan = LessonPlan.find_or_create_by_key(params[:key])
    else
      @lesson_plan = current_lesson_plan
    end
    @planned_lessons = @lesson_plan.planned_lessons.published
    @shared = params[:key]

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
        files = @lesson_plan.files

        unless files.all?(&:present?)
          raise Exception.new("lesson plan files not present")
        end

        send_archive(files)
      end
    end
  end

  def update
    @lesson_plan = current_lesson_plan

    if @lesson_plan.update_attributes(lesson_plan_params)
      respond_to do |format|
        format.json { render "lesson_plans/_lesson_plan" }
        format.html { redirect_back fallback_location: "/lesson-plan" }
      end
    end
  end

  def create_lessons_by_topic
    topic = Topic.find(params[:topic_id])
    @lesson_plan = current_lesson_plan!
    @lesson_plan.lessons |= topic.lessons

    respond_to do |format|
      format.json{ render json: [@lesson_plan.lessons.pluck(:id), topic.lessons.pluck(:id)] }
      format.html{ redirect_to topic_path(topic) }
    end
  end

  def create_lesson
    lesson = Lesson.find(params[:lesson_id])
    @lesson_plan = current_lesson_plan!
    @lesson_plan.lessons << lesson

    respond_to do |format|
      format.json{ render json: @lesson_plan.lessons.pluck(:id) }
      format.html{ redirect_to topic_lesson_path(lesson.topic, lesson.level) }
    end
  end

  def destroy_lessons_by_topic
    topic = Topic.find(params[:topic_id])
    @lesson_plan = current_lesson_plan
    lessons = topic.lessons

    lessons.each do |lesson|
      current_planned_lesson(lesson).destroy
    end

    respond_to do |format|
      format.json{ render json: [@lesson_plan.lessons.pluck(:id), topic.lessons.pluck(:id)] }
      format.html{ redirect_to topic_path(topic) }
    end
  end

  def destroy_lesson
    lesson = Lesson.find(params[:lesson_id])
    @lesson_plan = current_lesson_plan

    @lesson_plan.planned_lessons.
      where(lesson_id: lesson.id).destroy_all

    respond_to do |format|
      format.json{ render json: @lesson_plan.lessons.pluck(:id) }
      format.html{ redirect_to topic_lesson_path(lesson.topic, lesson.level) }
    end
  end

  private

  def lesson_plan_params
    params[:lesson_plan].permit(planned_lessons_attributes: [:id, :_destroy, :position])
  end
end
