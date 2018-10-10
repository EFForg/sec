class LessonsController < ApplicationController
  include ContentPermissioning
  include Pdfing
  include LessonPlanning
  include Previewing

  breadcrumbs "Security Education" => routes.root_path,
              "Lessons" => routes.topics_path

  def show
    @topic = Topic.friendly.find(params[:topic_id])
    protect_unpublished! @topic
    @lesson = @topic.lessons.with_level(params[:id]).take
    redirect_to @topic && return if @lesson.nil?

    breadcrumbs @topic.name

    og_object @lesson, description: ""

    respond_to do |format|
      format.html { render "topics/show" }
      format.js
      format.pdf do
        if Rails.env.development?
          UpdateLessonPdf.perform_now(@lesson.id)
          send_file(@lesson.reload.pdf.path, disposition: "inline")
        else
          redirect_to @lesson.pdf.url
        end
      end
    end
  end

  def preview
    protect_previews!
    @preview = true
    @topic = Topic.friendly.find(params[:topic_id])
    @topic, lessons = @topic.preview(preview_params.to_h)
    lessons.map!(&:first)
    @topic.lessons = lessons.select(&:published)
    @lesson = lessons.select { |l| l.level == params[:id] }.first
    breadcrumbs @topic.name
    og_object @lesson, description: ""
    render "show"
  end

  private

  def preview_params
    ActionController::Parameters.new(JSON.parse(request.raw_post))
      .require(:topic)
      .permit(:name, :description, :summary, :body, :next_article_id,
              admin_lessons_attributes: [:id, :level_id, :topic_id,
                                         :instructor_students_ratio,
                                         :objective, :notes, :body,
                                         :relevant_articles,
                                         :recommended_reading, :prerequisites,
                                         :suggested_materials,
                                         duration: %i(hours minutes),
                                         material_ids: [],
                                         advice_ids: []])
  end
end
