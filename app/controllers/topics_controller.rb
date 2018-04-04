class TopicsController < ApplicationController
  include ContentPermissioning
  include Tagging

  breadcrumbs "Security Education" => routes.root_path,
              "Lessons" => routes.topics_path

  skip_before_action :verify_authenticity_token, only: :show

  def index
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

  private

  def taggable_type
    Topic
  end
end
