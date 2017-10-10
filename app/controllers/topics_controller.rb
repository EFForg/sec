class TopicsController < ApplicationController
  def index
    @title = "Lesson Topics"
    @topics = Topic.all
  end

  def show
    @topic = Topic.friendly.find(params[:id])
  end
end
