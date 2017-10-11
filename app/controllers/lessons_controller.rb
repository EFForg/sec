class LessonsController < ApplicationController
  def show
    @topic = Topic.friendly.find(params[:topic_id])
    @lesson = @topic.lessons.with_level(params[:id]).take
    if @lesson.nil? or @lesson.level_id == 0
      redirect_to @topic
    else
      render "topics/show"
    end
  end
end
