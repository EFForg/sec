class TopicsController < ApplicationController
  def index
    @title = "Lesson Topics"
    @topics = topics_scope.published.order(published_at: :desc)
    @tags = ActsAsTaggableOn::Tag.joins(:taggings).
            where(taggings: { taggable_type: "Topic" }).
            distinct
  end

  def show
    @topic = Topic.published.friendly.find(params[:id])
    @lesson = @topic.lessons.published.take!

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
