module LessonsHelper
  def lesson_path(topic, lesson)
    return [topic] if lesson.level_id == 0
    [topic, lesson]
  end

  def difficulty_tag(level_id)
    levels = Array(level_id).map do |id|
      c = (Lesson::LEVELS[id] || "?")
      content_tag(:span, class: "difficulty-tag #{c[0]}"){ c.capitalize }
    end
    safe_join(levels)
  end

  def cache_key_for_topics(topics)
    [Topic.all.cache_key, topics.current_page, params[:tag]]
  end
end
