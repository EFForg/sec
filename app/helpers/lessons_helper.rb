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

  def lesson_path(topic, lesson)
    return [topic] if lesson.level_id == 0
    [topic, lesson]
  end

  def difficulty_tag(level_id)
    levels = Array(level_id).map do |id|
      c = (Lesson::LEVELS[id] || "?")[0]
      content_tag(:span, class: "difficulty-tag #{c}"){ c }
    end
    safe_join(levels)
  end

  def difficulty_legend
    levels = Lesson::LEVELS.each_pair.map do |level, name|
      content_tag(:li) {
        difficulty_tag(level) + name.capitalize
      }
    end

    content_tag(:ul, class: "difficulty-legend") { safe_join(levels) }
  end

  def cache_key_for_topics(topics)
    [Topic.all.cache_key, topics.current_page, params[:tag]]
  end
end
