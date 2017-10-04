class Lesson < ApplicationRecord
  belongs_to :topic
  before_save :set_duration

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
