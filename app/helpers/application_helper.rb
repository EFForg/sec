module ApplicationHelper
  def preview(html)
    allowed_tags = %w(a b strong i em u s strike del)
    truncate_html(sanitize(html, tags: allowed_tags), length: 500)
  end

  def tags(object)
  end

  def duration(time)
    if time
      distance_of_time_in_words(time)
    end
  end

  def materials_path
    "/materials"
  end
end
