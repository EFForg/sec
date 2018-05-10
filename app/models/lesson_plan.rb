require_dependency "duration"
require_dependency "pdf_template"

class LessonPlan < ApplicationRecord
  has_many :planned_lessons,
    counter_cache: "lessons_count",
    after_remove: ->(plan, _){ plan.update_column(:pdf_file_updated_at, nil) }
  has_one :lesson_plan_link

  has_many :lessons, ->{ reorder!.merge(PlannedLesson.ordered) },
    through: :planned_lessons

  accepts_nested_attributes_for :planned_lessons,
                                allow_destroy: true

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
      template: "lesson_plans/show.pdf.erb",
      source: { controller: "lesson_plans", action: "show", id: key }
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

  def lengthy?
    duration.length >= 4.hours
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

  def key
    LessonPlanLink.find_or_create_by(lesson_ids: lessons.pluck(:id)).key
  end

  def self.find_or_create_by_key(key)
    link = LessonPlanLink.find_by!(key: key)
    return link.lesson_plan if link.lesson_plan

    LessonPlan.create.tap do |plan|
      link.update_attribute(:lesson_plan, plan)
      plan.lesson_ids = link.lesson_ids
    end
  end
end
