module TopicsHelper
  def duration_range(topic)
    min = topic.lessons.first.duration.in_words
    return min if topic.lessons.count == 1
    return "#{min} - #{topic.total_duration.in_words}"
  end
end
