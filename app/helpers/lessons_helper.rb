module LessonsHelper
  def duration_in_words(lesson)
    duration = []
    if lesson.duration_hours && lesson.duration_hours > 0
      duration.push(pluralize(lesson.duration_hours, "hour"))
    end
    if lesson.duration_minutes && lesson.duration_minutes > 0
      duration.push(pluralize(lesson.duration_minutes, "minute"))
    end
    duration.join(" and ")
  end
end
