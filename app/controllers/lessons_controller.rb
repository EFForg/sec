class LessonsController < ApplicationController
  include ContentPermissioning
  include Pdfing

  def show
    @topic = Topic.friendly.find(params[:topic_id])
    protect_unpublished! @topic
    @lesson = @topic.lessons.with_level(params[:id]).take
    redirect_to @topic && return if @lesson.nil?

    respond_to do |format|
      format.html { render "topics/show" }
      format.md
      format.js
      format.pdf do
        if Rails.env.development?
          UpdateLessonPdf.perform_now(@lesson.id)
          send_file(@lesson.reload.pdf.path, disposition: "inline")
        else
          redirect_to @lesson.pdf.url
        end
      end
    end
  end
end
