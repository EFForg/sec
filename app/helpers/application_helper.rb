module ApplicationHelper
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
