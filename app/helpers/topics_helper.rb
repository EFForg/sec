module TopicsHelper
  def duration(time)
    if time
      distance_of_time_in_words(time)
    end
  end
end
