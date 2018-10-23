class TopicsController < ApplicationController
  include ContentPermissioning
  include Tagging
  include LessonPlanning

  breadcrumbs "Security Education" => routes.root_path,
              "Lessons" => routes.topics_path

  def index
    @page = Page.find_by!(name: "topics-overview")
    @topics = tagged_scope.preload(:lessons, :tags).
      published.order(created_at: :desc).
      page(params[:page])
  end

  def show
    @topic = Topic.friendly.find(params[:id])
    protect_unpublished! @topic

    @lesson = @topic.lessons.take unless @topic.description?

    breadcrumbs @topic.name
    og_object @topic, description: ""

    respond_to do |format|
      format.html
      format.js
    end
  end

  def preview
    protect_previews!
    @preview = true
    @topic = Topic.friendly.find(params[:id])
    @topic, lessons = @topic.preview(preview_params.to_h)
    @topic.lessons = lessons.select(&:published)
    @lesson = lessons[0] unless @topic.description?
    @preview_params = { topic: preview_params.to_h }
    og_object @topic
    breadcrumbs @topic.name
    render "topics/show"
  end

  private

  def preview_params
    params.require(:topic)
          .permit(:name, :description, :summary, :body, :next_article_id,
                  admin_lessons_attributes: [:id, :level_id, :topic_id,
                                             :instructor_students_ratio,
                                             :objective, :notes, :body,
                                             :relevant_articles,
                                             :recommended_reading,
                                             :prerequisites,
                                             :suggested_materials,
                                             duration: %i(hours minutes),
                                             material_ids: [],
                                             advice_ids: []])
  end

  def taggable_type
    Topic
  end
end
