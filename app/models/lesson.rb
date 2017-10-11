class Lesson < ApplicationRecord
  LEVELS = { 0 => "base", 1 => "medium", 2 => "advanced" }

  belongs_to :topic

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

  acts_as_taggable

  default_scope { order(level_id: :asc) }
  scope :with_level, -> (name) { where(level_id: LEVELS.invert[name]) }

  validates :level_id, uniqueness: { scope: :topic },
                    presence: true,
                    inclusion: { in: 0..LEVELS.length,
                                 message: "must be a valid level" }

  accepts_nested_attributes_for :lesson_prereqs, allow_destroy: true, reject_if: :resource_blank
  accepts_nested_attributes_for :lesson_materials, allow_destroy: true, reject_if: :resource_blank
  accepts_nested_attributes_for :lesson_articles, allow_destroy: true, reject_if: :resource_blank

  before_save :set_duration

  def resource_blank(attributes)
    attributes[:resource_id].blank?
  end

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

  def set_duration
    if @duration_hours.present? or @duration_minuts.present?
      self.duration = @duration_hours.hours.to_i + @duration_minutes.minutes.to_i
    end
  end

  def duration_hours
    (duration/3600).floor if duration.present? and duration > 0
  end

  def duration_minutes
    if duration.present? and duration > 0
      minutes = (duration % 3600)/60
      minutes.round
    end
  end

  def duration_hours=(hours)
    duration_will_change! unless hours == duration_hours
    @duration_hours = hours.to_f
  end

  def duration_minutes=(minutes)
    duration_will_change! unless minutes == duration_minutes
    @duration_minutes = minutes.to_f
  end
end
