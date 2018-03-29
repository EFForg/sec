require_dependency "duration"

class LessonPlan < ApplicationRecord
  has_many :lesson_plan_lessons,
           after_add: ->(plan, _){ plan.update(pdf_file_updated_at: nil) },
           after_remove: ->(plan, _){ plan.update(pdf_file_updated_at: nil) }

  has_many :lessons, through: :lesson_plan_lessons

  accepts_nested_attributes_for :lesson_plan_lessons,
                                allow_destroy: true

  validates_uniqueness_of :key
  before_validation :set_key, on: :create

  mount_uploader :pdf_file, GenericUploader

  def pdf
    unless pdf_file_updated_at.try(:>=, lessons.pluck(:updated_at).max)
      self.recreate_pdf_file
    end

    pdf_file
  end

  def recreate_pdf_file
    controller = LessonPlansController.new
    controller.instance_variable_set("@lesson_plan", self)

    doc = controller.render_to_string(
      template: "lesson_plans/show.pdf.erb",
      layout: "layouts/pdf.html.erb"
    )

    pdf = WickedPdf.new.pdf_from_string(
      doc,
      pdf: "Lesson Plan",
      margin: {
        top: "0.6in",
        bottom: "1in",
        left: "1in",
        right: "0.6in"
      }
    )

    tmp = Tempfile.new(["lesson_plan", ".pdf"])
    tmp.binmode
    tmp.write(pdf)
    tmp.flush
    tmp.rewind

    update!(pdf_file: tmp, pdf_file_updated_at: Time.now)
  end

  def pdf_file_filename
    "Lesson Plan.pdf"
  end

  def duration
    Duration.new(lessons.sum :duration)
  end

  def to_param
    key
  end

  private

  def set_key
    self.key = SecureRandom.urlsafe_base64
  end
end
