json.call(@lesson_plan, :id, :lessons_count)
json.id @lesson_plan.id
json.lessons_count @lesson_plan.lessons.count
json.duration_in_words @lesson_plan.duration.in_words
json.lessons @lesson_plan.planned_lessons.published do |planned_lesson|
  json.position planned_lesson.position
  json.id planned_lesson.id
  json.lesson_id planned_lesson.lesson.id
  json.name planned_lesson.topic.name
  json.duration planned_lesson.duration.in_words
  if planned_lesson.topic.icon
    json.rendered_icon link_to image_tag(planned_lesson.topic.icon.url),
      [planned_lesson.topic, planned_lesson.lesson]
  end
  json.difficulty_tag difficulty_tag(planned_lesson.level_id)
end
json.links do
  json.download lesson_plan_path(@lesson_plan, format: "zip")
end
