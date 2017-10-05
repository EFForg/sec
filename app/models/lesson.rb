class Lesson < ApplicationRecord
  LEVELS = { 0 => 'Base', 1 => 'Medium', 2 => 'Advanced' }

  belongs_to :topic
  has_many :lesson_resources

  has_many :lesson_prereqs,
           ->{ where(content_type: 'Lesson') },
           class_name: 'LessonResource'

  has_many :prereqs, through: :lesson_prereqs,
           source: :content, source_type: 'Lesson',
           class_name: "Lesson"

  default_scope { order(level_id: :asc) }
  validates :level_id, uniqueness: { scope: :topic },
                    presence: true,
                    inclusion: { in: 0..LEVELS.length,
                                 message: 'must be a valid level' }

  accepts_nested_attributes_for :lesson_prereqs, allow_destroy: true

  before_save :set_duration

  def self.unused_levels
    used_levels = all.pluck(:level_id).uniq
    LEVELS.select{ |key, value| used_levels.exclude?(key) }.invert
  end

  def level
    LEVELS[level_id]
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
