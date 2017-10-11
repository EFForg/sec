class TopicsController < ApplicationController
  def index
    @title = "Lesson Topics"
    @topics = Topic.published.order(published_at: :desc)
  end

  def show
    @topic = Topic.published.friendly.find(params[:id])
    @lesson = @topic.lessons.published.first || not_found
  end
end
