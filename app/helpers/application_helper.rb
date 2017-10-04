module ApplicationHelper
  def tags(object)
  end

  def duration(time)
    distance_of_time_in_words(60 * 60 * time)
  end

  def topics_path
    "/topics"
  end

  def articles_path
    "/articles"
  end

  def materials_path
    "/materials"
  end

  def blog_path
    "/blog"
  end
end
