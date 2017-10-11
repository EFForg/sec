class TopicsController < ApplicationController
  def index
    @title = "Lesson Topics"
    @topics = Topic.all
  end

  def show
    @topic = Topic.friendly.find(params[:id])
    @lesson = @topic.lessons.first || not_found
  end
end
