require_dependency "duration"

class Lesson < ApplicationRecord
  LEVELS = { 0 => "beginning", 1 => "intermediate", 2 => "advanced" }

  belongs_to :topic, touch: true

  has_many :lesson_resources

  has_many :lesson_prereqs,
           ->{ where(resource_type: "Lesson") },
           class_name: "LessonResource"

  has_many :lesson_materials,
           ->{ where(resource_type: "Material") },
           class_name: "LessonResource"

  has_many :lesson_articles,
           ->{ where(resource_type: "Article") },
           class_name: "LessonResource"

  has_many :prereqs, through: :lesson_prereqs,
           source: :resource, source_type: "Lesson",
           class_name: "Lesson"

  has_many :materials, through: :lesson_materials,
           source: :resource, source_type: "Material",
           class_name: "Material"

  has_many :advice, through: :lesson_articles,
           source: :resource, source_type: "Article",
           class_name: "Article"

  default_scope { order(level_id: :asc) }
  scope :with_level, -> (name) { where(level_id: LEVELS.invert[name]) }

  validates :level_id, uniqueness: { scope: :topic },
                    presence: true,
                    inclusion: { in: 0..LEVELS.length,
                                 message: "must be a valid level" }

  accepts_nested_attributes_for :lesson_prereqs, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :lesson_materials, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :lesson_articles, allow_destroy: true, reject_if: :all_blank

  serialize :duration, Duration

  delegate :published?, :unpublished, to: :topic
  scope :published, ->{ joins(:topic).merge(Topic.published) }

  mount_uploader :pdf, PdfUploader
  after_validation :update_pdf

  def name
    "#{topic.name}: #{level}"
  end

  def self.unused_levels
    used_levels = all.pluck(:level_id).uniq
    LEVELS.select{ |key, value| used_levels.exclude?(key) }.invert
  end

  def level
    LEVELS[level_id]
  end

  def to_param
    level
  end

  def update_pdf
    unless changes.keys == ["pdf"]
      controller = LessonsController.new
      controller.instance_variable_set("@topic", topic)
      controller.instance_variable_set("@lesson", self)

      doc = controller.render_to_string(
        template: "lessons/show.pdf.erb",
        layout: "layouts/pdf.html.erb"
      )

      pdf = WickedPdf.new.pdf_from_string(doc, pdf: topic.name)

      tmp = Tempfile.new(["lesson", ".pdf"])
      tmp.binmode
      tmp.write(pdf)
      tmp.flush
      tmp.rewind

      self.pdf = tmp
    end
  end
end
