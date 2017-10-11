module LessonsHelper
  def duration_in_words(lesson)
    duration = []
    duration.push(pluralize(lesson.duration_hours, "hour")) if lesson.duration_hours > 0
    duration.push(pluralize(lesson.duration_minutes, "minute")) if lesson.duration_minutes > 0
    duration.join(" and ")
  end
end
