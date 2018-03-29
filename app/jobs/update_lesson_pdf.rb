require_dependency "pdf_template"

class UpdateLessonPdf < ApplicationJob
  queue_as :pdfs

  def perform(lesson_id)
    lesson = Lesson.find(lesson_id)

    pdf = PdfTemplate.new(
      name: lesson.topic.name,
      template: "lessons/show.pdf.erb"
    )

    lesson.update!(pdf: pdf.render(topic: lesson.topic, lesson: lesson))
  end
end
