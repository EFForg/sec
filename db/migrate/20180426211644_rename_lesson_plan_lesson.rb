class RenameLessonPlanLesson < ActiveRecord::Migration[5.1]
  def change
    rename_table :lesson_plan_lessons, :planned_lessons
  end
end
