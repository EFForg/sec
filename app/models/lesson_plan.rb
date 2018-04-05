require_dependency "duration"
require_dependency "pdf_template"

class LessonPlan < ApplicationRecord
  has_many :lesson_plan_lessons,
           after_remove: ->(plan, _){ plan.update_column(:pdf_file_updated_at, nil) }

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
    pdf = PdfTemplate.new(
      name: "Lesson Plan",
      template: "lesson_plans/show.pdf.erb"
    )

    update!(pdf_file: pdf.render(lesson_plan: self),
            pdf_file_updated_at: Time.now)
  end

  def pdf_file_filename
    "Lesson Plan.pdf"
  end

  def duration
    Duration.new(lessons.sum :duration)
  end

  def to_param
    persisted? ? key : "current"
  end

  private

  def set_key
    self.key = SecureRandom.urlsafe_base64
  end
end
