module ApplicationHelper
  def tags(object)
  end

  def duration(time)
    distance_of_time_in_words(60 * 60 * time)
  end

  def materials_path
    "/materials"
  end
end
