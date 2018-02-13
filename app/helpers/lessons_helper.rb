module LessonsHelper
  def lesson_path(topic, lesson)
    [topic, lesson]
  end

  def difficulty_class(level_id)
    (Lesson::LEVELS[level_id] || "?")[0]
  end

  def difficulty_tag(level_id)
    levels = Array(level_id).map do |id|
      c = difficulty_class(id)
      content_tag(:span, class: "difficulty-tag #{c}"){ c.capitalize }
    end
    safe_join(levels)
  end

  def cache_key_for_topics(topics)
    [Topic.all.cache_key, topics.current_page, params[:tag]]
  end
end
