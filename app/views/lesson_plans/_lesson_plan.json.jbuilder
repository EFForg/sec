json.call(@lesson_plan, :id, :lessons_count)
json.id @lesson_plan.id
json.lessons_count @lesson_plan.lessons.count
json.duration_in_words @lesson_plan.duration.in_words
json.lessons @lesson_plan.planned_lessons.published do |planned_lesson|
  json.position planned_lesson.position
  json.id planned_lesson.id
  lesson = planned_lesson.lesson
  json.lesson_id lesson.id
  json.name lesson.topic.name
  json.duration lesson.duration.in_words
  if lesson.topic.icon
    json.rendered_icon link_to image_tag(lesson.topic.icon.url), [lesson.topic, lesson]
  end
  json.difficulty_tag difficulty_tag(lesson.level_id)
end
json.links do
  json.download lesson_plan_path(@lesson_plan, format: "zip")
end
