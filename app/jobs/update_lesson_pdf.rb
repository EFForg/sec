class UpdateLessonPdf < ApplicationJob
  queue_as :pdfs

  def perform(lesson_id)
    lesson = Lesson.find(lesson_id)

    controller = LessonsController.new
    controller.instance_variable_set("@topic", lesson.topic)
    controller.instance_variable_set("@lesson", lesson)

    doc = controller.render_to_string(
      template: "lessons/show.pdf.erb",
      layout: "layouts/pdf.html.erb"
    )

    pdf = WickedPdf.new.pdf_from_string(doc, pdf: lesson.topic.name)

    tmp = Tempfile.new(["lesson", ".pdf"])
    tmp.binmode
    tmp.write(pdf)
    tmp.flush
    tmp.rewind

    lesson.update!(pdf: tmp)
  end
end
