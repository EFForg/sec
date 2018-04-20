require_dependency "duration"
require_dependency "pdf_template"

class LessonPlan < ApplicationRecord
  has_many :lesson_plan_lessons, -> { order(:position) },
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

    locals = {
      lesson_plan: self,
      materials: bundled_materials
    }

    update!(pdf_file: pdf.render(locals),
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

  def bundled_materials
    url_helper = Rails.application.routes.url_helpers

    Material.all.select do |material|
      path = url_helper.material_path(material)
      lessons.any? do |lesson|
        lesson.suggested_materials[path]
      end
    end
  end

  def files
    lessons.published.flat_map do |lesson|
      files = Array(lesson.pdf)
      files.concat(lesson.materials.flat_map(&:files))
    end.uniq
  end

  private

  def set_key
    self.key = SecureRandom.urlsafe_base64
  end
end
