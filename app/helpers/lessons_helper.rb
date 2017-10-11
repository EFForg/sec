module LessonsHelper
  def duration_in_words(lesson)
    duration = []
    if lesson.duration
      duration.push(pluralize(lesson.duration.hours, "hour")) unless lesson.duration.hours.zero?
      duration.push(pluralize(lesson.duration.minutes, "minute")) unless lesson.duration.minutes.zero?
    end
    duration.join(" and ")
  end
end
