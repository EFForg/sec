class Lesson < ApplicationRecord
  LEVELS = { 0 => "base", 1 => "medium", 2 => "advanced" }

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

  before_validation :set_duration

  delegate :published?, :unpublished, to: :topic
  scope :published, ->{ joins(:topic).merge(Topic.published) }

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

  def duration
    if self[:duration]
      @duration ||= Duration.new((self[:duration]/3600).floor,
                                 (self[:duration]%3600)/60)
    end
  end

  def duration=(val)
    case val
    when Duration
      @duration = val
    when Hash
      @duration = Duration.new(val[:hours], val[:minutes])
    else
      @duration = nil
      self[:duration] = val
    end
  end

  def set_duration
    if @duration
      duration_will_change! unless self[:duration] == @duration.to_i
      self[:duration] = @duration.to_i
    end
  end

  private

  Duration = Struct.new(:hours, :minutes) do
    def to_i
      hours.hours + minutes.minutes
    end
  end
end
