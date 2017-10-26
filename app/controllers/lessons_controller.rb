class LessonsController < ApplicationController
  include ContentPermissioning

  def show
    @topic = Topic.friendly.find(params[:topic_id])
    protect_unpublished! @topic
    @lesson = @topic.lessons.with_level(params[:id]).take
    redirect_to @topic && return if @lesson.nil?

    respond_to do |format|
      format.html { render "topics/show" }
      format.js
      format.pdf { redirect_to @lesson.pdf.url }
    end
  end
end
