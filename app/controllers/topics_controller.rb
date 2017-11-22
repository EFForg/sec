class TopicsController < ApplicationController
  include ContentPermissioning
  include Tagging

  breadcrumbs "Security Education" => routes.root_path,
              "Lessons" => routes.topics_path

  def index
    @topics = tagged_scope.preload(:lessons, :tags).
      published.order(created_at: :desc).
      page(params[:page])
  end

  def show
    @topic = Topic.friendly.find(params[:id])
    protect_unpublished! @topic
    @lesson = @topic.lessons.take!
    breadcrumbs @topic.name

    respond_to do |format|
      format.html
      format.js { render "lessons/show" }
    end
  end

  private

  def taggable_type
    Topic
  end
end
