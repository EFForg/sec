class LessonsController < ApplicationController
  def show
    @topic = Topic.friendly.find(params[:topic_id])
    @lesson = @topic.lessons.with_level(params[:id]).take
    if @lesson
      render "topics/show"
    else
      redirect_to @topic unless @lesson
    end
  end
end
