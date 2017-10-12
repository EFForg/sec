class TopicsController < ApplicationController
  def index
    @title = "Lesson Topics"
    @topics = Topic.all
  end

  def show
    @topic = Topic.friendly.find(params[:id])
    @lesson = @topic.lessons.take!

    respond_to do |format|
      format.html
      format.js { render "lessons/show" }
    end
  end
end
