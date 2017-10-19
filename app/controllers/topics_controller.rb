class TopicsController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Lessons" => routes.topics_path

  def index
    @topics = topics_scope.preload(:lessons, :tags).
              published.order(published_at: :desc).
              page(params[:page])
    @tags = ActsAsTaggableOn::Tag.joins(:taggings).
            where(taggings: { taggable_type: "Topic" }).
            distinct
  end

  def show
    @topic = Topic.published.friendly.find(params[:id])
    @lesson = @topic.lessons.take!
    breadcrumbs @topic.name

    respond_to do |format|
      format.html
      format.js { render "lessons/show" }
    end
  end

  private

  def topics_scope
    if params[:tag]
      Topic.tagged_with(params[:tag])
    else
      Topic.all
    end
  end
end
